import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "local.clock"

  property bool alt: false
  property date displayDate: clock.date

  readonly property string activeFormat: alt
    ? setting("formatAlt", "d MMMM 'W'ww yyyy")
    : (bar && bar.vertical ? setting("verticalFormat", "HH\n—\nmm") : setting("format", "dddd HH:mm"))
  readonly property string displayText: formatted(displayDate)
  readonly property var verticalLines: displayText.split("\n")

  function refresh() {
    displayDate = new Date()
  }

  function isoWeek(date) {
    var d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()))
    var day = d.getUTCDay() || 7
    d.setUTCDate(d.getUTCDate() + 4 - day)
    var yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1))
    return Math.ceil(((d - yearStart) / 86400000 + 1) / 7)
  }

  function isoWeekLiteral(date) {
    var week = isoWeek(date)
    return (week < 10 ? "0" : "") + week
  }

  function formatted(date) {
    return Qt.locale("fr_CA").toString(date, activeFormat.replace(/ww/g, isoWeekLiteral(date)))
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
    onDateChanged: root.displayDate = date
  }

  IpcHandler {
    target: "omarchy.clock"
    function refresh(): void { root.refresh() }
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.vertical ? "" : root.displayText
    labelVisible: !root.vertical
    hasVisualContent: root.vertical ? root.verticalLines.length > 0 : text !== ""
    fixedHeight: root.vertical ? root.verticalLines.length * Style.bar.iconSlot : -1
    horizontalMargin: 8.75
    verticalPadding: 8.75
    onPressed: function(button) {
      if (!root.bar) return
      if (button === Qt.RightButton) root.bar.run("omarchy-menu-timezone")
      else root.bar.run("pgrep -x waycal >/dev/null && pkill -x waycal || LC_ALL=fr_CA.UTF-8 LC_TIME=fr_CA.UTF-8 /home/po/bin/waycal")
    }

    Column {
      visible: root.vertical
      anchors.fill: parent

      Repeater {
        model: root.verticalLines

        OpticalGlyph {
          required property string modelData
          width: button.width
          height: Style.bar.iconSlot
          text: modelData
          fontFamily: button.fontFamily
          fontSize: button.fontSize
          color: button.foreground
        }
      }
    }
  }
}
