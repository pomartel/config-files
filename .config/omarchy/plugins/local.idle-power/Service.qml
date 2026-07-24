import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import "IdleModel.js" as IdleModel

Item {
  id: root

  // Injected by omarchy-shell's service loader.
  property var shell: null

  readonly property string home: Quickshell.env("HOME")
  readonly property string stayAwakeStateDir: home + "/.local/state/omarchy/indicators"
  readonly property string stayAwakeStatePath: stayAwakeStateDir + "/stay-awake"
  readonly property int defaultScreensaverSeconds: 150
  readonly property int defaultMonitorOffSeconds: 600
  readonly property int defaultSuspendSeconds: 7200
  readonly property var idleConfig: shell && shell.shellConfig && shell.shellConfig.idle ? shell.shellConfig.idle : ({})
  readonly property int screensaverTimeoutSeconds: secondsFromConfig(idleConfig.screensaver, defaultScreensaverSeconds)
  readonly property int monitorOffTimeoutSeconds: secondsFromConfig(idleConfig.monitorOff, defaultMonitorOffSeconds)
  readonly property int suspendTimeoutSeconds: secondsFromConfig(idleConfig.suspend, defaultSuspendSeconds)
  readonly property int firstIdleTimeoutSeconds: Math.min(screensaverTimeoutSeconds, monitorOffTimeoutSeconds, suspendTimeoutSeconds)
  readonly property int monitorOffDelaySeconds: Math.max(0, monitorOffTimeoutSeconds - firstIdleTimeoutSeconds)
  readonly property int suspendDelaySeconds: Math.max(0, suspendTimeoutSeconds - firstIdleTimeoutSeconds)
  readonly property bool idleEnabled: stayAwakeStateLoaded && !stayAwake
  readonly property string screensaverClass: "org.omarchy.screensaver"

  property bool stayAwake: false
  property bool stayAwakeStateLoaded: false
  property bool idledThisCycle: false
  property bool monitorsOffThisCycle: false
  property bool monitorWakePending: false
  property bool suspendRequestedThisCycle: false
  property double idleCycleStartedAt: 0
  property double suspendRequestedAt: 0
  property string lastEvent: "starting"
  property string lastEventAt: ""
  property int lastMonitorOffExitCode: 0
  property int lastMonitorOffExitStatus: 0
  property int lastWakeExitCode: 0
  property int lastWakeExitStatus: 0
  property int lastSuspendExitCode: 0
  property int lastSuspendExitStatus: 0
  property var screensaverWindows: ({})
  property int screensaverWindowCount: 0

  function secondsFromConfig(value, fallback) {
    return IdleModel.secondsFromConfig(value, fallback)
  }

  function nowIso() {
    return new Date().toISOString()
  }

  function logEvent(event, details) {
    var suffix = details === undefined || details === null || details === "" ? "" : ": " + String(details)
    root.lastEventAt = nowIso()
    root.lastEvent = event + suffix
    console.log("local idle-power " + root.lastEventAt + " " + root.lastEvent)
  }

  function elapsedIdleSeconds() {
    if (root.idleCycleStartedAt <= 0) return 0
    return Math.max(0, (Date.now() - root.idleCycleStartedAt) / 1000)
  }

  function atSuspendDeadline() {
    // Allow one second for timers and Hyprland window events arriving in a
    // different order at a shared lock/suspend deadline.
    return elapsedIdleSeconds() >= Math.max(0, root.suspendTimeoutSeconds - 1)
  }

  function requestSuspend(reason) {
    if (!root.idleEnabled || root.suspendRequestedThisCycle) return

    root.suspendRequestedThisCycle = true
    root.suspendRequestedAt = Date.now()
    monitorOffTimer.stop()
    suspendTimer.stop()
    screensaverLaunchGraceTimer.stop()
    logEvent("suspend-requested", reason || "timeout")
    suspendRequestGuardTimer.restart()

    suspendProcess.command = ["systemctl", "--check-inhibitors=yes", "suspend"]
    suspendProcess.running = true
  }

  function turnOffMonitors(reason) {
    if (!root.idleEnabled || !root.idledThisCycle || root.monitorsOffThisCycle || root.suspendRequestedThisCycle) return

    root.monitorsOffThisCycle = true
    monitorOffTimer.stop()
    logEvent("monitors-off-requested", reason || "timeout")
    monitorOffProcess.command = ["omarchy-brightness-display", "off"]
    monitorOffProcess.running = true
  }

  function wakeMonitors(reason) {
    if (!root.monitorsOffThisCycle) return

    root.monitorsOffThisCycle = false
    logEvent("monitors-wake-requested", reason || "idle-cycle-cancel")
    if (monitorOffProcess.running) {
      root.monitorWakePending = true
      return
    }
    startMonitorWake()
  }

  function startMonitorWake() {
    root.monitorWakePending = false
    wakeProcess.command = ["omarchy-system-wake"]
    wakeProcess.running = true
  }

  function startIdleCycle() {
    if (root.idledThisCycle) return

    root.idledThisCycle = true
    root.monitorsOffThisCycle = false
    root.suspendRequestedThisCycle = false
    root.suspendRequestedAt = 0
    // IdleMonitor fires after firstIdleTimeoutSeconds, so reconstruct the
    // beginning of the user-idle interval for wall-clock deadline checks.
    root.idleCycleStartedAt = Date.now() - root.firstIdleTimeoutSeconds * 1000
    resetScreensaverWindows()
    logEvent("idle-cycle-start", "screensaver=" + root.screensaverTimeoutSeconds + " monitorOff=" + root.monitorOffTimeoutSeconds + " suspend=" + root.suspendTimeoutSeconds)

    if (root.monitorOffDelaySeconds === 0) turnOffMonitors("monitor-timeout-immediate")
    else monitorOffTimer.restart()

    if (root.suspendDelaySeconds === 0) requestSuspend("suspend-timeout-immediate")
    else suspendTimer.restart()
    if (root.firstIdleTimeoutSeconds === root.screensaverTimeoutSeconds)
      screensaverLaunchGraceTimer.restart()
  }

  function cancelIdleCycle(reason) {
    logEvent("idle-cycle-cancel", reason || "requested")
    monitorOffTimer.stop()
    suspendTimer.stop()
    screensaverLaunchGraceTimer.stop()
    suspendRequestGuardTimer.stop()
    root.idledThisCycle = false
    root.suspendRequestedThisCycle = false
    root.idleCycleStartedAt = 0
    root.suspendRequestedAt = 0
    resetScreensaverWindows()
    wakeMonitors(reason)
  }

  function resetScreensaverWindows() {
    root.screensaverWindows = ({})
    root.screensaverWindowCount = 0
  }

  function setScreensaverWindow(address, visible) {
    var next = IdleModel.screensaverWindowsAfter(root.screensaverWindows, address, visible)
    root.screensaverWindows = next.windows
    root.screensaverWindowCount = next.count
  }

  function handleScreensaverWindowOpened(address) {
    setScreensaverWindow(address, true)
    screensaverLaunchGraceTimer.stop()
  }

  function handleScreensaverWindowClosed(address) {
    setScreensaverWindow(address, false)
    if (!root.idleEnabled || !root.idledThisCycle || root.screensaverWindowCount > 0) return
    if (root.suspendRequestedThisCycle) return

    // At a shared lock/suspend deadline the built-in lock service may close
    // the screensaver just before this plugin's Timer event is delivered.
    if (atSuspendDeadline()) requestSuspend("deadline-during-screensaver-close")
    else cancelIdleCycle("screensaver-dismissed")
  }

  function eventParts(event, count) {
    return IdleModel.eventParts(event, count)
  }

  function handleHyprlandEvent(event) {
    var name = String(event && event.name ? event.name : "")
    if (name === "openwindow") {
      var open = eventParts(event, 4)
      if (String(open[2] || "") === root.screensaverClass) handleScreensaverWindowOpened(open[0])
    } else if (name === "closewindow") {
      var close = eventParts(event, 1)
      var address = String(close[0] || "")
      if (root.screensaverWindows[address]) handleScreensaverWindowClosed(address)
    }
  }

  function handleActiveSignal() {
    if (!root.idledThisCycle) return

    if (root.suspendRequestedThisCycle) {
      if (Date.now() - root.suspendRequestedAt < suspendRequestGuardTimer.interval) {
        logEvent("idle-monitor-active", "suspend transition remains latched")
        return
      }
      cancelIdleCycle("activity-after-suspend-request")
      return
    }

    // The built-in idle service launches the screensaver at the same first
    // timeout. Its window can make the compositor report synthetic activity.
    if (root.screensaverWindowCount > 0 || screensaverLaunchGraceTimer.running) {
      logEvent("idle-monitor-active", "screensaver cycle remains armed")
      return
    }

    if (atSuspendDeadline()) requestSuspend("deadline-during-active-signal")
    else cancelIdleCycle("activity")
  }

  function handleIdleChanged() {
    logEvent("idle-monitor", idleMonitor.isIdle ? "idle" : "active")
    if (!root.idleEnabled) return
    if (idleMonitor.isIdle) startIdleCycle()
    else handleActiveSignal()
  }

  function refreshStayAwakeState() {
    if (!stayAwakeStateProbe.running) stayAwakeStateProbe.running = true
  }

  function applyStayAwake(value) {
    var next = !!value
    var changed = !root.stayAwakeStateLoaded || root.stayAwake !== next
    root.stayAwake = next
    root.stayAwakeStateLoaded = true
    if (!changed) return

    logEvent("stay-awake", next ? "enabled" : "disabled")
    if (next) cancelIdleCycle("stay-awake")
    else Qt.callLater(root.handleIdleChanged)
  }

  function statusJson() {
    return JSON.stringify({
      enabled: root.idleEnabled,
      stayAwake: root.stayAwake,
      idle: idleMonitor.isIdle,
      inIdleCycle: root.idledThisCycle,
      monitorsOff: root.monitorsOffThisCycle,
      monitorWakePending: root.monitorWakePending,
      suspendRequested: root.suspendRequestedThisCycle,
      screensaver: root.screensaverTimeoutSeconds,
      monitorOff: root.monitorOffTimeoutSeconds,
      suspend: root.suspendTimeoutSeconds,
      monitorOffDelay: root.monitorOffDelaySeconds,
      suspendDelay: root.suspendDelaySeconds,
      elapsedIdle: Math.floor(root.elapsedIdleSeconds()),
      screensaverWindows: root.screensaverWindowCount,
      timers: {
        monitorOff: monitorOffTimer.running,
        suspend: suspendTimer.running,
        screensaverLaunchGrace: screensaverLaunchGraceTimer.running,
        suspendRequestGuard: suspendRequestGuardTimer.running
      },
      processes: {
        monitorOff: {
          running: monitorOffProcess.running,
          lastExitCode: root.lastMonitorOffExitCode,
          lastExitStatus: root.lastMonitorOffExitStatus
        },
        wake: {
          running: wakeProcess.running,
          lastExitCode: root.lastWakeExitCode,
          lastExitStatus: root.lastWakeExitStatus
        },
        suspend: {
          running: suspendProcess.running,
          lastExitCode: root.lastSuspendExitCode,
          lastExitStatus: root.lastSuspendExitStatus
        }
      },
      lastEvent: root.lastEvent,
      lastEventAt: root.lastEventAt
    })
  }

  IdleMonitor {
    id: idleMonitor
    enabled: root.idleEnabled
    timeout: root.firstIdleTimeoutSeconds
    respectInhibitors: true
    onIsIdleChanged: root.handleIdleChanged()
  }

  Timer {
    id: monitorOffTimer
    interval: root.monitorOffDelaySeconds * 1000
    repeat: false
    onTriggered: root.turnOffMonitors("monitor-timeout")
  }

  Timer {
    id: suspendTimer
    interval: root.suspendDelaySeconds * 1000
    repeat: false
    onTriggered: root.requestSuspend("suspend-timeout")
  }

  Timer {
    id: screensaverLaunchGraceTimer
    interval: 3000
    repeat: false
    onTriggered: {
      if (root.idleEnabled && root.idledThisCycle && root.screensaverWindowCount === 0 && !idleMonitor.isIdle)
        root.cancelIdleCycle("screensaver-not-running")
    }
  }

  Timer {
    id: suspendRequestGuardTimer
    interval: 10000
    repeat: false
    onTriggered: {
      // Timers freeze during sleep. After resume this fires and allows real
      // user activity to re-arm the next idle cycle without re-suspending.
      if (root.suspendRequestedThisCycle && !idleMonitor.isIdle)
        root.cancelIdleCycle("active-after-suspend-transition")
    }
  }

  Connections {
    target: Hyprland
    function onRawEvent(event) { root.handleHyprlandEvent(event) }
  }

  Process {
    id: monitorOffProcess
    onExited: function(exitCode, exitStatus) {
      root.lastMonitorOffExitCode = exitCode
      root.lastMonitorOffExitStatus = exitStatus
      root.logEvent("monitor-off-process-exit", "exitCode=" + exitCode + " status=" + exitStatus)
      if (root.monitorWakePending) root.startMonitorWake()
    }
  }

  Process {
    id: wakeProcess
    onExited: function(exitCode, exitStatus) {
      root.lastWakeExitCode = exitCode
      root.lastWakeExitStatus = exitStatus
      root.logEvent("wake-process-exit", "exitCode=" + exitCode + " status=" + exitStatus)
    }
  }

  Process {
    id: suspendProcess
    onExited: function(exitCode, exitStatus) {
      root.lastSuspendExitCode = exitCode
      root.lastSuspendExitStatus = exitStatus
      root.logEvent("suspend-process-exit", "exitCode=" + exitCode + " status=" + exitStatus)
    }
  }

  Process {
    id: stayAwakeStateProbe
    command: ["bash", "-c", "mkdir -p \"$HOME/.local/state/omarchy/indicators\"; if [[ -f $HOME/.local/state/omarchy/indicators/stay-awake ]]; then echo yes; else echo no; fi"]
    stdout: SplitParser {
      onRead: function(line) { root.applyStayAwake(String(line).trim() === "yes") }
    }
    onExited: function() { stayAwakeStateDirWatcher.reload() }
  }

  FileView {
    id: stayAwakeStateDirWatcher
    path: root.stayAwakeStateDir
    watchChanges: true
    printErrors: false
    onFileChanged: root.refreshStayAwakeState()
  }

  Component.onCompleted: {
    logEvent("service-ready")
    refreshStayAwakeState()
  }

  IpcHandler {
    target: "idle-power"

    function status(): string {
      return root.statusJson()
    }

    function debug(): string {
      return root.statusJson()
    }
  }
}
