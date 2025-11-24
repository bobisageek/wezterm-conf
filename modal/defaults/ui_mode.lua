local wezterm = require("wezterm")
local act = wezterm.action
local modal = require("modal.core")

-- From smartsplits.nvim
local function is_vim(pane)
  -- this is set by the smart-splits.nvim plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == "true"
end

local function activate_pane_direction(key, direction, mods, vim_mods)
  return {
    key = key,
    mods = mods,
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = vim_mods },
        }, pane)
      else
        if direction == "Left" or direction == "Right" then
          wezterm.emit("wrapping-move-pane-" .. direction:lower(), win, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction }, pane)
        end
      end
    end),
  }
end

local function adjust_pane_size(key, direction, mods, vim_key, vim_mods, cells)
  return {
    key = key,
    mods = mods,
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = vim_key, mods = vim_mods },
        }, pane)
      else
        win:perform_action({ AdjustPaneSize = { direction, cells } }, pane)
      end
    end),
  }
end

local hints = {
  { keys = "Pane" },
  { mods = "C?", keys = "hjkl", "Go/Resize" },
  { keys = "-|", "V/H Split" },
  { keys = "z", "Zoom" },
  { keys = "r", "Rotate" },
  { keys = "q", "Close  " },
  { keys = "Tab", "" },
  { keys = "t/T", "New/Close" },
  { keys = "H/L,S?-Tab", "Go" },
  { keys = "JK", "Move" },
  { keys = "n", "Rename" },
  { mods = "A", keys = "t", "Selector" },
  { keys = "w/W", "Next/Prev WS" },
}

local function status_line(cfg, accent_color)
  local s = require("modal.status")
  local c = s.status_line_defaults(cfg, accent_color)
  local v = s.status_line("UI", c.dressing, c.colors, c.separators, hints)
  return function()
    do
      return v
    end
  end
end

return {
  status_line = status_line,
  key_table = {
    -- Cancel the mode by pressing escape
    {
      key = "Escape",
      action = modal.exit_mode("UI"),
    },
    { key = "c", mods = "CTRL", action = modal.exit_mode("UI") },

    -- Activate panes
    activate_pane_direction("h", "Left", "", "CTRL"),
    activate_pane_direction("j", "Down", "", "CTRL"),
    activate_pane_direction("k", "Up", "", "CTRL"),
    activate_pane_direction("l", "Right", "", "CTRL"),

    -- Resize
    adjust_pane_size("h", "Left", "CTRL", "h", "CTRL|ALT", 1),
    adjust_pane_size("l", "Right", "CTRL", "l", "CTRL|ALT", 1),
    adjust_pane_size("k", "Up", "CTRL", "k", "CTRL|ALT", 1),
    adjust_pane_size("j", "Down", "CTRL", "j", "CTRL|ALT", 1),
    adjust_pane_size("LeftArrow", "Left", "", "h", "CTRL|ALT", 1),
    adjust_pane_size("RightArrow", "Right", "", "l", "CTRL|ALT", 1),
    adjust_pane_size("UpArrow", "Up", "", "k", "CTRL|ALT", 1),
    adjust_pane_size("DownArrow", "Down", "", "j", "CTRL|ALT", 1),

    -- Zoom toggle
    { key = "z", action = wezterm.action.TogglePaneZoomState },

    -- Split pane
    { key = "-", action = wezterm.action.SplitVertical },
    { key = "|", mods = "SHIFT", action = wezterm.action.SplitHorizontal },

    -- Close pane
    { key = "q", action = wezterm.action.CloseCurrentPane({ confirm = true }) },

    -- Rotate panes
    { key = "r", action = act.RotatePanes("Clockwise") },
    { key = "R", action = act.RotatePanes("CounterClockwise") },

    -- Selecting
    { key = "S", mods = "SHIFT", action = act.PaneSelect({}) },
    -- Swap
    { key = "s", action = act.PaneSelect({ mode = "SwapWithActive" }) },

    -- Tabs
    { key = "t", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "T", mods = "SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },

    { key = "H", mods = "SHIFT", action = act.ActivateTabRelative(-1) },
    { key = "L", mods = "SHIFT", action = act.ActivateTabRelative(1) },
    { key = "Tab", mods = "", action = act.ActivateTabRelative(1) },
    { key = "Tab", mods = "SHIFT", action = act.ActivateTabRelative(-1) },

    { key = "J", mods = "SHIFT", action = act.MoveTabRelative(-1) },
    { key = "K", mods = "SHIFT", action = act.MoveTabRelative(1) },

    { key = "t", mods = "ALT", action = wezterm.action.ShowTabNavigator },

    {
      key = "n",
      action = act.Multiple({
        act.PopKeyTable,
        act.PromptInputLine({
          description = "Enter new name for tab",
          action = wezterm.action_callback(function(window, pane, name)
            if name then
              window:active_tab():set_title(name)
            end
            window:perform_action(
              act.ActivateKeyTable({
                name = "UI",
                one_shot = false,
              }),
              pane
            )
          end),
        }),
      }),
    },

    -- Workspace
    { key = "w", action = act.SwitchWorkspaceRelative(1) },
    { key = "W", mods = "SHIFT", action = act.SwitchWorkspaceRelative(-1) },

    -- New window
    { key = "N", mods = "SHIFT", action = wezterm.action.SpawnWindow },

    -- Move pane to new window
    {
      key = "P",
      mods = "SHIFT",
      action = wezterm.action.Multiple({
        wezterm.action_callback(function(_, pane)
          pane:move_to_new_window()
        end),
        modal.exit_mode("UI"),
      }),
    },
    {
      key = "p",
      action = wezterm.action.Multiple({
        wezterm.action_callback(function(_, pane)
          pane:move_to_new_tab()
        end),
        modal.exit_mode("UI"),
      }),
    },
    -- font size
    { key = "+", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
    { key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },

    -- toggle fullscreen
    {
      key = "f",
      action = wezterm.action.ToggleFullScreen,
    },
  },
}
