local wez = require("wezterm")
local modal = require("modal.core")

local module = {}

local icons = {
  left_seperator = wez.nerdfonts.ple_left_half_circle_thick,
  key_hint_seperator = " | ",
  mod_seperator = "-",
}

local function colors(config, color)
  return {
    key_hint_seperator = color,
    key = color,
    hint = color,
    bg = config.colors.background,
    left_bg = color,
  }
end

local default_modes = {
  { name = "Scroll", file = "scroll_mode", key = { key = "s", mods = "ALT" } },
  { name = "copy_mode", key = { key = "c", mods = "ALT" } },
  { name = "UI", file = "ui_mode", key = { key = "u", mods = "ALT" } },
}

function module.apply_to(cfg)
  for i, mode in ipairs(default_modes) do
    local ansis = cfg.colors.ansi
    local accent_color = (#ansis == 0) and cfg.colors.foreground or ansis[(i % #ansis) + 1]
    local module_name = "modal.defaults." .. (mode.file or mode.name)
    local status_text = require(module_name).get_hint_status_text(
      icons,
      colors(cfg, accent_color),
      { bg = accent_color, fg = cfg.colors.background }
    )
    modal.add_mode(mode.name, require(module_name).key_table, status_text)
    table.insert(cfg.keys, {
      key = mode.key.key,
      mods = mode.key.mods,
      action = modal.activate_mode(mode.name),
    })
  end
  cfg.key_tables = modal.key_tables
end

return module
