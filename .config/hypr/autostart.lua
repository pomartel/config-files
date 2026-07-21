-- Personal startup commands, ported from autostart.conf.

o.launch_on_start("solaar -w hide --restart-on-wake-up -b solaar")
o.exec_on_start("sleep 3; uwsm-app -- 1password --silent")
o.exec_on_start("hyprland-monitor-attached ~/bin/hypr-monitor-toggle ~/bin/hypr-monitor-toggle")

-- This intentionally runs on config load, matching the old `exec` directive.
hl.exec_cmd("hypr-monitor-toggle")

hl.on("hyprland.start", function()
  hl.dispatch(hl.dsp.exec_cmd(
    "uwsm-app -- omarchy-launch-browser",
    { workspace = "1 silent" }
  ))
end)

hl.on("hyprland.start", function()
  hl.dispatch(hl.dsp.exec_cmd(
    [[uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" tmux]],
    { workspace = "2 silent" }
  ))
end)
hl.on("hyprland.start", function()
  hl.dispatch(hl.dsp.focus({ workspace = 1 }))
end)
o.exec_on_start("trash-empty 30")
