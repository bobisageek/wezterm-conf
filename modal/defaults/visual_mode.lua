-- NOTE: This file is used to make status text for copy mode visual selections
local wezterm = require("wezterm")

local hints = {
  { mods = "S/C/A", keys = "v", "Change Visual Mode" },
  { keys = "o/O", "Swap select ends" },
  { keys = "s/S", "Semantic Jump" },
  { keys = "y", "Copy and exit" },
  { keys = "hjkl", "Move" },
}

local function status_line(cfg, accent_color)
  local s = require("modal.status")
  local c = s.status_line_defaults(cfg, accent_color)
  return function()
    do
      local v = s.status_line("V-" .. (wezterm.GLOBAL.visual_mode or ""), c.dressing, c.colors, c.separators, hints)
      return v
    end
  end
end

---Create status text with hints
---@param hint_icons {left_seperator: string, key_hint_seperator: string, mod_seperator: string}
---@param hint_colors {key_hint_seperator: string, key: string, hint: string, bg: string, left_bg: string}
---@param mode_colors {bg: string, fg: string}
---@return string
local function get_hint_status_text(hint_icons, hint_colors, mode_colors)
  return wezterm.format({
    -- ...
  })
end

---Create mode status text
---@param bg string
---@param fg string
---@param left_seperator string
---@return string
local function get_mode_status_text(left_seperator, bg, fg)
  return wezterm.format({
    { Attribute = { Intensity = "Bold" } },
    { Foreground = { Color = bg } },
    { Text = left_seperator },
    { Foreground = { Color = fg } },
    { Background = { Color = bg } },
    { Text = "Visual  " },
  })
end

return {
  status_line = status_line,
}
