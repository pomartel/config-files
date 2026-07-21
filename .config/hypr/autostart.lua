-- Personal startup commands, ported from autostart.conf.

o.launch_on_start("solaar -w hide --restart-on-wake-up -b solaar")
o.exec_on_start("sleep 3; uwsm-app -- 1password --silent")
o.exec_on_start("hyprland-monitor-attached ~/bin/hypr-monitor-toggle ~/bin/hypr-monitor-toggle")

-- This intentionally runs on config load, matching the old `exec` directive.
hl.exec_cmd("hypr-monitor-toggle")

o.exec_on_start([[hyprctl dispatch exec "[workspace 1 silent] uwsm-app -- omarchy-launch-browser"]])
o.exec_on_start([[hyprctl dispatch exec '[workspace 2 silent] uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" tmux']])
o.exec_on_start("hyprctl dispatch workspace 1")
o.exec_on_start("trash-empty 30")