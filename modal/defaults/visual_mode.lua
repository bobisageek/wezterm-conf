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

return {
  status_line = status_line,
}
