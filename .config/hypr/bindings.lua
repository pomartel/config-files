local bindings = {
  { "SUPER + ALT + RETURN", "Terminal", [[uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)"]] },
  { "SUPER + RETURN", "Tmux", [[uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" tmux]] },
  { "SUPER + SHIFT + RETURN", "Browser", "omarchy-launch-browser" },

  { "SUPER + SHIFT + A", "ChatGPT", "omarchy-launch-webapp https://chatgpt.com --profile-directory=Default" },
  { "SUPER + SHIFT + ALT + A", "ChatGPT (special workspace)", "toggle-special-workspace ai && omarchy-launch-or-focus-webapp brave-chatgpt https://chatgpt.com --profile-directory=Default" },
  { "SUPER + SHIFT + B", "Browser", "omarchy-launch-browser --profile-directory=Default" },
  { "SUPER + SHIFT + ALT + B", "Browser (school)", "omarchy-launch-browser --profile-directory=School" },
  { "SUPER + SHIFT + CTRL + B", "Browser (private)", "omarchy-launch-browser --private" },
  { "SUPER + SHIFT + C", "Calendar Pouding", "omarchy-launch-or-focus-webapp brave-calendar https://calendar.google.com/calendar/u/0/r --profile-directory=Default" },
  { "SUPER + SHIFT + ALT + C", "Calendar Rosemont", [[omarchy-launch-or-focus-webapp "Agenda - Pierre Olivier Martel - Outlook" https://outlook.office.com/calendar/view/month --profile-directory=School]] },
  { "SUPER + SHIFT + E", "Email Pouding", "omarchy-launch-or-focus-webapp brave-mail https://mail.google.com/mail/u/0/ --profile-directory=Default" },
  { "SUPER + SHIFT + ALT + E", "Email Rosemont", [[omarchy-launch-or-focus-webapp "Courriel - Pierre Olivier Martel - Outlook" https://outlook.office.com/mail/ --profile-directory=School]] },
  { "SUPER + SHIFT + F", "File manager", "uwsm-app -- nautilus --new-window Downloads" },
  { "SUPER + ALT + SHIFT + F", "File manager (cwd)", [[uwsm-app -- nautilus --new-window "$(omarchy-cmd-terminal-cwd)"]] },
  { "SUPER + SHIFT + G", "Messenger", "omarchy-launch-or-focus-webapp brave-messenger https://www.facebook.com/messages --profile-directory=Default" },
  { "SUPER + SHIFT + ALT + G", "Microsoft Teams", "omarchy-launch-or-focus-webapp brave-teams.microsoft https://teams.cloud.microsoft/ --profile-directory=School" },
  { "SUPER + SHIFT + CTRL + G", "WhatsApp", "omarchy-launch-or-focus-webapp brave-web.whatsapp https://web.whatsapp.com/ --profile-directory=Default" },
  { "SUPER + SHIFT + L", "Calibre", "gtk-launch calibre-gui" },
  { "SUPER + SHIFT + N", "Neovim", "omarchy-launch-editor" },
  { "SUPER + SHIFT + M", "Music (Spotify)", "omarchy-launch-or-focus spotify" },
  { "SUPER + SHIFT + ALT + M", "Music TUI", "omarchy-launch-or-focus-tui cliamp" },
  { "SUPER + SHIFT + O", "Only Office", [[omarchy-launch-or-focus "^ONLYOFFICE$" "gtk-launch onlyoffice-desktopeditors"]] },
  { "SUPER + SHIFT + ALT + O", "Obsidian", [[omarchy-launch-or-focus "^obsidian$" "uwsm-app -- obsidian"]] },
  { "SUPER + SHIFT + P", "Apple Photos", "omarchy-launch-or-focus-webapp brave-www.icloud https://www.icloud.com/photos/ --profile-directory=Default" },
  { "SUPER + SHIFT + T", "Todoist", "toggle-special-workspace todos && omarchy-launch-or-focus-webapp brave-app.todoist https://app.todoist.com/app/ --profile-directory=Default" },
  { "SUPER + SHIFT + ALT + T", "Apple reminders", "omarchy-launch-or-focus-webapp brave-www.icloud https://www.icloud.com/reminders/ --profile-directory=Default" },
  { "SUPER + SHIFT + W", "Typora", [[omarchy-launch-or-focus ^Typora$ "uwsm-app -- typora --enable-wayland-ime"]] },
  { "SUPER + SHIFT + Y", "YouTube", "omarchy-launch-or-focus-webapp brave-youtube https://youtube.com/ --profile-directory=Default" },
  { "SUPER + SHIFT + ALT + Y", "Netflix", "omarchy-launch-or-focus-webapp brave-www.netflix https://www.netflix.com/browse --profile-directory=Default" },
  { "SUPER + SHIFT + X", "1Password", "uwsm-app -- 1password" },
  { "SUPER + SHIFT + Z", "Zed Editor", "gtk-launch dev.zed.Zed" },

  { "SUPER + CTRL + ESCAPE", "Suspend system", "systemctl suspend", { locked = true } },
  { "SUPER + CTRL + ALT + ESCAPE", "Hibernate system", "systemctl hibernate", { locked = true } },
  { "SUPER + ALT + C", "Confettis animation", "confetti" },
  { "SUPER + CTRL + D", "Waybar Calendar", "pkill -x waycal || LC_TIME=fr_CA.UTF-8 waycal" },
  { "SUPER + CTRL + P", "HDMI Toggle (Projector)", "hdmi-toggle", { locked = true } },
}

for _, binding in ipairs(bindings) do
  hl.unbind(binding[1])
  o.bind(binding[1], binding[2], binding[3], binding[4])
end

hl.unbind("SUPER + Q")
o.bind("SUPER + Q", "Close active window", hl.dsp.window.close())

hl.unbind("SUPER + W")
o.bind("SUPER + W", "Send SUPER+W to CTRL+W", hl.dsp.send_shortcut({ mods = "CTRL", key = "W", window = "activewindow" }))
