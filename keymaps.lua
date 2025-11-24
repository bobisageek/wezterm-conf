local wez = require("wezterm")
local act = wez.action

local function splitBiggerDim(_, pane)
  local dims = pane:get_dimensions()
  wez.log_info(dims)
  local direction = dims.pixel_height > dims.pixel_width and "Bottom" or "Right"
  pane:split({ direction = direction })
end

local keys = {
  {
    mods = "ALT",
    key = "LeftArrow",
    action = wez.action.EmitEvent("wrapping-move-pane-left"),
  },
  {
    mods = "ALT",
    key = "RightArrow",
    action = wez.action.EmitEvent("wrapping-move-pane-right"),
  },
  {
    mods = "ALT",
    key = "n",
    action = wez.action_callback(splitBiggerDim),
  },
  {
    mods = "SUPER",
    key = "h",
    action = act.SpawnCommandInNewTab({ args = { "htop" } }),
  },
  {
    mods = "ALT",
    key = "Enter",
    action = wez.action.DisableDefaultAssignment,
  },
  {
    mods = "CTRL | SHIFT",
    key = "A",
    action = act.ActivateCommandPalette,
  },
}

local function apply_to(cfg)
  if not cfg.keys then
    cfg.keys = {}
  end
  for _, k in ipairs(keys) do
    table.insert(cfg.keys, k)
  end
end

return {
  apply_to = apply_to,
}
