local w = require("wezterm")

local cfg = w.config_builder()
-- load event handlers
require("pane_events")
-- window styling/scheming
cfg.color_scheme = "tokyonight"

if not cfg.colors then
  if cfg.color_scheme then
    cfg.colors = w.color.get_builtin_schemes()[cfg.color_scheme]
  else
    cfg.colors = w.color.get_default_colors()
  end
end
cfg.colors.background = "#050505"

cfg.text_background_opacity = 0.9
cfg.window_background_opacity = 0.95
cfg.use_fancy_tab_bar = false
cfg.tab_bar_at_bottom = true

cfg.window_frame = {
  font_size = 12,
}
cfg.window_padding = {
  left = 0,
  right = "2px",
  top = 0,
  bottom = 0,
}

cfg.inactive_pane_hsb = {
  saturation = 0.2,
  brightness = 0.2,
}

cfg.font = w.font("JetBrainsMono Nerd Font")

-- shell
cfg.default_prog = { "nu" }
cfg.warn_about_missing_glyphs = false

require("keymaps").apply_to(cfg)
require("modes").apply_to(cfg)

return cfg
