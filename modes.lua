local wez = require("wezterm")
local modal = require("modal.core")

local module = {}

local left_div = "\u{e0d6}"
local right_div = "\u{e0d7}"

local icons = {
  left_seperator = left_div,
  key_hint_seperator = right_div .. left_div,
  mod_seperator = "-",
}

local function colors(config, color)
  return {
    key_hint_seperator = color,
    key = config.colors.foreground,
    hint = config.colors.foreground,
    bg = config.colors.tab_bar.background or config.colors.background,
    left_bg = color,
  }
end

local default_modes = {
  { name = "Scroll", file = "scroll_mode", key = { key = "s", mods = "ALT" } },
  { name = "copy_mode", display_name = "Copy", key = { key = "c", mods = "ALT" } },
  { name = "UI", file = "ui_mode", key = { key = "u", mods = "ALT" } },
}

function module.apply_to(cfg)
  for i, mode in ipairs(default_modes) do
    local ansis = cfg.colors.brights
    local accent_color = (#ansis == 0) and cfg.colors.foreground or ansis[(i % #ansis) + 1]
    local module_name = "modal.defaults." .. (mode.file or mode.name)
    local theMod = require(module_name)
    local status_text = theMod.status_line and theMod.status_line(cfg, accent_color)
      or theMod.get_hint_status_text(
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
