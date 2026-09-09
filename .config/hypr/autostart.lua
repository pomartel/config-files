-- Personal startup commands, ported from autostart.conf.

o.launch_on_start("hyprsunset")
o.exec_on_start("sleep 3; uwsm-app -- 1password --silent")
-- hyprmoncfgd is the sole monitor writer and handles hotplug/lid/resume events.

o.launch_on_start("omarchy-launch-browser")

hl.on("hyprland.start", function()
  hl.exec_cmd("xdg-terminal-exec", { workspace = "2 silent" })
  hl.dispatch(hl.dsp.focus({ workspace = 1 }))
end)
o.exec_on_start("trash-empty 30")
