local hints = {
  { mods = "A", keys = "n", "Split" },
  { mods = "CS", keys = "t", "New Tab" },
}

local function status_line(cfg)
  local s = require("modal.status")
  local c = s.status_line_defaults(cfg, "yellow")
  return s.status_line("Normal", c.dressing, c.colors, c.separators, hints)
end

return { status_line = status_line }
