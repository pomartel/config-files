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
  readonly property int defaultSuspendSeconds: 7200
  readonly property var idleConfig: shell && shell.shellConfig && shell.shellConfig.idle ? shell.shellConfig.idle : ({})
  readonly property int screensaverTimeoutSeconds: secondsFromConfig(idleConfig.screensaver, defaultScreensaverSeconds)
  readonly property int suspendTimeoutSeconds: secondsFromConfig(idleConfig.suspend, defaultSuspendSeconds)
  readonly property int firstIdleTimeoutSeconds: Math.min(screensaverTimeoutSeconds, suspendTimeoutSeconds)
  readonly property int suspendDelaySeconds: Math.max(0, suspendTimeoutSeconds - firstIdleTimeoutSeconds)
  readonly property bool idleEnabled: stayAwakeStateLoaded && !stayAwake
  readonly property string screensaverClass: "org.omarchy.screensaver"

  property bool stayAwake: false
  property bool stayAwakeStateLoaded: false
  property bool idledThisCycle: false
  property bool suspendRequestedThisCycle: false
  property double idleCycleStartedAt: 0
  property double suspendRequestedAt: 0
  property string lastEvent: "starting"
  property string lastEventAt: ""
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
    console.log("local idle-suspend " + root.lastEventAt + " " + root.lastEvent)
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
    suspendTimer.stop()
    screensaverLaunchGraceTimer.stop()
    logEvent("suspend-requested", reason || "timeout")
    suspendRequestGuardTimer.restart()

    suspendProcess.command = ["systemctl", "--check-inhibitors=yes", "suspend"]
    suspendProcess.running = true
  }

  function startIdleCycle() {
    if (root.idledThisCycle) return

    root.idledThisCycle = true
    root.suspendRequestedThisCycle = false
    root.suspendRequestedAt = 0
    // IdleMonitor fires after firstIdleTimeoutSeconds, so reconstruct the
    // beginning of the user-idle interval for wall-clock deadline checks.
    root.idleCycleStartedAt = Date.now() - root.firstIdleTimeoutSeconds * 1000
    resetScreensaverWindows()
    logEvent("idle-cycle-start", "screensaver=" + root.screensaverTimeoutSeconds + " suspend=" + root.suspendTimeoutSeconds)

    if (root.suspendDelaySeconds === 0) {
      requestSuspend("suspend-timeout-immediate")
      return
    }

    suspendTimer.restart()
    if (root.firstIdleTimeoutSeconds === root.screensaverTimeoutSeconds)
      screensaverLaunchGraceTimer.restart()
  }

  function cancelIdleCycle(reason) {
    logEvent("idle-cycle-cancel", reason || "requested")
    suspendTimer.stop()
    screensaverLaunchGraceTimer.stop()
    suspendRequestGuardTimer.stop()
    root.idledThisCycle = false
    root.suspendRequestedThisCycle = false
    root.idleCycleStartedAt = 0
    root.suspendRequestedAt = 0
    resetScreensaverWindows()
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
      suspendRequested: root.suspendRequestedThisCycle,
      screensaver: root.screensaverTimeoutSeconds,
      suspend: root.suspendTimeoutSeconds,
      suspendDelay: root.suspendDelaySeconds,
      elapsedIdle: Math.floor(root.elapsedIdleSeconds()),
      screensaverWindows: root.screensaverWindowCount,
      timers: {
        suspend: suspendTimer.running,
        screensaverLaunchGrace: screensaverLaunchGraceTimer.running,
        suspendRequestGuard: suspendRequestGuardTimer.running
      },
      process: {
        running: suspendProcess.running,
        lastExitCode: root.lastSuspendExitCode,
        lastExitStatus: root.lastSuspendExitStatus
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
    target: "idle-suspend"

    function status(): string {
      return root.statusJson()
    }

    function debug(): string {
      return root.statusJson()
    }
  }
}
