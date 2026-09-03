-- Personal startup commands, ported from autostart.conf.

o.launch_on_start("solaar -w hide --restart-on-wake-up -b solaar")
o.launch_on_start("hyprsunset")
o.exec_on_start("sleep 3; uwsm-app -- 1password --silent")
-- o.exec_on_start("hyprland-monitor-attached ~/bin/hypr-monitor-toggle ~/bin/hypr-monitor-toggle")

-- This intentionally runs on config load, matching the old `exec` directive.
hl.exec_cmd("hypr-monitor-toggle")

o.launch_on_start("omarchy-launch-browser")

hl.on("hyprland.start", function()
  hl.exec_cmd("xdg-terminal-exec", { workspace = "2 silent" })
  hl.dispatch(hl.dsp.focus({ workspace = 1 }))
end)
o.exec_on_start("trash-empty 30")
