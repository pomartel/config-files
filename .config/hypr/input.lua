-- Personal input configuration, ported from input.conf.

hl.config({
  input = {
    kb_layout = "ca",
    kb_model = "pc105",
    kb_options = "grp:alt_space_toggle",
    repeat_rate = 40,
    repeat_delay = 300,
    numlock_by_default = true,
    natural_scroll = true,
    sensitivity = 0.1,
    touchpad = {
      natural_scroll = true,
      tap_and_drag = false,
      clickfinger_behavior = true,
      scroll_factor = 1.3,
    },
  },
})

hl.device({ name = "snsl0028:00-2c2f:0028-touchpad", scroll_factor = 1 })
hl.device({ name = "tpps/2-elan-trackpoint", sensitivity = -0.8 })

o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
