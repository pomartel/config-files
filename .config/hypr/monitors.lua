-- Personal monitor configuration, ported from monitors.conf.

hl.env("GDK_SCALE", "2")

hl.monitor({ output = "eDP-1", mode = "2880x1800@120", position = "auto", scale = 2 })
hl.monitor({ output = "desc:Dell Inc. DELL U3225QE HHJXB34", mode = "highrr", position = "auto", scale = 1.6 })
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto", scale = "auto", mirror = "eDP-1" })

for workspace = 1, 5 do
  hl.workspace_rule({ workspace = tostring(workspace), monitor = "DP-1" })
end
hl.workspace_rule({ workspace = "6", monitor = "eDP-1" })
