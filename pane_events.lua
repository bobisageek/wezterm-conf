local wez = require("wezterm")
local act = wez.action

local function move(direction)
  return function(window, pane)
    local opposites = { Left = "Right", Right = "Left" }
    local opposite = opposites[direction]
    local relativeNumbers = { Left = -1, Right = 1 }
    local relativeNumber = relativeNumbers[direction]
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

wez.on("wrapping-move-pane-left", move("Left"))
wez.on("wrapping-move-pane-right", move("Right"))
