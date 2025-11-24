local wezterm = require("wezterm")
local modal = require("modal.core")

local hints = {
  { mods = "C", keys = "p/n/󰓢", "Prev/Next Result" },
  { mods = "C", keys = "r", "Cycle Match Type" },
  { mods = "C", keys = "", "Clear search" },
  { keys = "Enter", "Accept Pattern" },
  { keys = "Esc", "End Search" },
}

local function status_line(cfg, accent_color)
  local s = require("modal.status")
  local c = s.status_line_defaults(cfg, accent_color)
  local v = s.status_line("Search", c.dressing, c.colors, c.separators, hints)
  return function()
    do
      return v
    end
  end
end

return {
  status_line = status_line,
  key_table = {
    {
      key = "Enter",
      mods = "NONE",
      action = wezterm.action.Multiple({
        wezterm.action_callback(function(window, pane)
          wezterm.emit("modal.enter", "copy_mode", window, pane)
        end),
        wezterm.action.CopyMode("AcceptPattern"),
      }),
    },
    {
      key = "Escape",
      action = wezterm.action_callback(function(window, pane)
        wezterm.GLOBAL.search_mode = false
        window:perform_action(modal.exit_mode("search_mode"), pane)
        window:perform_action(modal.activate_mode("copy_mode"), pane)
      end),
    },
    {
      key = "c",
      mods = "CTRL",
      action = wezterm.action_callback(function(window, pane)
        wezterm.GLOBAL.search_mode = false
        window:perform_action(modal.exit_mode("search_mode"), pane)
        window:perform_action(modal.activate_mode("copy_mode"), pane)
      end),
    },
    { key = "n", mods = "CTRL", action = wezterm.action.CopyMode("NextMatch") },
    { key = "p", mods = "CTRL", action = wezterm.action.CopyMode("PriorMatch") },
    { key = "r", mods = "CTRL", action = wezterm.action.CopyMode("CycleMatchType") },
    { key = "u", mods = "CTRL", action = wezterm.action.CopyMode("ClearPattern") },
    {
      key = "PageUp",
      mods = "NONE",
      action = wezterm.action.CopyMode("PriorMatchPage"),
    },
    {
      key = "PageDown",
      mods = "NONE",
      action = wezterm.action.CopyMode("NextMatchPage"),
    },
    { key = "UpArrow", mods = "NONE", action = wezterm.action.CopyMode("PriorMatch") },
    { key = "DownArrow", mods = "NONE", action = wezterm.action.CopyMode("NextMatch") },
  },
}
