-- Personal window rules, ported from windows.conf.

o.window({ tag = "centered-floating-window" }, { float = true, center = true })
o.window({ tag = "fixed-centered-floating-window" }, { float = true, center = true, size = { 1200, 750 } })

o.window("^(xdg-desktop-portal-gtk)$", { tag = "+floating-window" })
o.window({ title = "^(Print|Imprimer)$" }, { tag = "+centered-floating-window" })
o.window("^(DesktopEditors|org.omarchy.nmtui-connect|nm-connection-editor)$", { tag = "+centered-floating-window" })

o.window("^(org.gnome.NautilusPreviewer)$", { tag = "-floating-window" })
o.window("^(org.gnome.NautilusPreviewer)$", { tag = "+centered-floating-window" })
o.window("^(org.gnome.NautilusPreviewer)$", { size = { "monitor_w*0.6", "monitor_h*0.85" } })

o.window("^(brave-app.todoist.*)$", { tag = "+fixed-centered-floating-window" })
o.window({ workspace = "special:ai" }, { tag = "+fixed-centered-floating-window" })
o.window("^Spotify$", { workspace = "6" })

o.window({ title = "^(Mode.*PIP.*Picture-in-Picture|.*Picture.?in.?[Pp]icture.*)$" }, { tag = "+pip" })
o.window({ tag = "pip" }, { move = { "monitor_w-window_w-20", "monitor_h-window_h-20" } })
