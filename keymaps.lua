local wez = require("wezterm")
local act = wez.action

local module = {}

local function move(direction, opposite, relativeNumber)
  return function(window, pane)
    local paneToLeft = window:active_tab():get_pane_direction(direction)
    if paneToLeft then
      wez.log_info("moving left a pane")
      -- paneToLeft:activate()
      window:perform_action(act.ActivatePaneDirection(direction), pane)
    else
      wez.log_info("moving left a tab")
      window:perform_action(act.ActivateTabRelative(relativeNumber), pane)
      while window:active_tab():get_pane_direction(opposite) do
        window:perform_action(act.ActivatePaneDirection(opposite), pane)
      end
    end
  end
end

local function splitBiggerDim(_, pane)
  local dims = pane:get_dimensions()
  wez.log_info(dims)
  local direction = dims.pixel_height > dims.pixel_width and "Bottom" or "Right"
  pane:split({ direction = direction })
end

local modalMenuKeyTable = {}

local keys = {
  {
    mods = "ALT",
    key = "LeftArrow",
    action = wez.action_callback(move("Left", "Right", -1)),
  },
  {
    mods = "ALT",
    key = "RightArrow",
    action = wez.action_callback(move("Right", "Left", 1)),
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
}

function module.apply_to(cfg)
  if not cfg.keys then
    cfg.keys = {}
  end
  for _, k in ipairs(keys) do
    table.insert(cfg.keys, k)
  end
end

return module
