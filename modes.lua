local wez = require("wezterm")
local modal = wez.plugin.require("https://github.com/MLFlexer/modal.wezterm")

local module = {}

local icons = {
  left_seperator = wez.nerdfonts.ple_left_half_circle_thick,
  key_hint_seperator = " | ",
  mod_seperator = "-",
}

local function colors(config)
  return {
    key_hint_seperator = config.colors.foreground,
    key = config.colors.foreground,
    hint = config.colors.foreground,
    bg = config.colors.background,
    left_bg = config.colors.background,
  }
end

local default_modes = {
  { name = "Scroll", file = "scroll_mode", color = "orange", key = { key = "s", mods = "ALT" } },
  { name = "copy_mode", color = "blue", key = { key = "c", mods = "ALT" } },
  { name = "UI", file = "ui_mode", color = "red", key = { key = "u", mods = "ALT" } },
}

function module.apply_to(cfg)
  modal.enable_defaults("https://github.com/MLFlexer/modal.wezterm")
  for _, mode in ipairs(default_modes) do
    local file_name = mode.file or mode.name
    local status_text = require(file_name).get_hint_status_text(
      icons,
      colors(cfg),
      { bg = mode.color or "orange", fg = cfg.colors.background }
    )
    modal.add_mode(mode.name, require(file_name).key_table, status_text)
    table.insert(cfg.keys, {
      key = mode.key.key,
      mods = mode.key.mods,
      action = modal.activate_mode(mode.name),
    })
  end
  cfg.key_tables = modal.key_tables
end

return module
