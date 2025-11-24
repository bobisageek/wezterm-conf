local wezterm = require("wezterm")
local act = wezterm.action
local modal = require("modal.core")

local hints = {
  { mods = "S?", keys = "j/k/󰓢", "1/5 Line Scroll" },
  { mods = "S?", keys = "d/u", "0.5/1 Page Scroll" },
  { keys = "p/n/{/}", "Prompt Scroll" },
  { keys = "g/G", "Top/Bottom" },
  { keys = "z", "Zoom" },
  { keys = "v", "Copy Mode" },
  { keys = "/", "Search Mode" },
}

local function status_line(cfg, accent_color)
  local s = require("modal.status")
  local c = s.status_line_defaults(cfg, accent_color)
  local v = s.status_line("Scroll", c.dressing, c.colors, c.separators, hints)
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
    { key = "Escape", action = modal.exit_mode("Scroll") },
    { key = "c", mods = "CTRL", action = modal.exit_mode("Scroll") },

    { key = "UpArrow", action = act.ScrollByLine(-1) },
    { key = "DownArrow", action = act.ScrollByLine(1) },
    { key = "k", action = act.ScrollByLine(-1) },
    { key = "j", action = act.ScrollByLine(1) },

    { key = "UpArrow", mods = "SHIFT", action = act.ScrollByLine(-5) },
    { key = "DownArrow", mods = "SHIFT", action = act.ScrollByLine(5) },
    { key = "K", mods = "SHIFT", action = act.ScrollByLine(-5) },
    { key = "J", mods = "SHIFT", action = act.ScrollByLine(5) },

    { key = "u", action = act.ScrollByPage(-0.5) },
    { key = "d", action = act.ScrollByPage(0.5) },
    { key = "U", mods = "SHIFT", action = act.ScrollByPage(-1) },
    { key = "D", mods = "SHIFT", action = act.ScrollByPage(1) },

    { key = "p", action = act.ScrollToPrompt(-1) },
    { key = "n", action = act.ScrollToPrompt(1) },
    { key = "{", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
    { key = "}", mods = "SHIFT", action = act.ScrollToPrompt(1) },

    { key = "g", action = act.ScrollToTop },
    { key = "G", mods = "SHIFT", action = act.ScrollToBottom },

    { key = "z", action = wezterm.action.TogglePaneZoomState },

    {
      key = "v",
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(modal.exit_mode("Scroll"), pane)
        window:perform_action(modal.activate_mode("copy_mode"), pane)
      end),
    },
    {
      key = "/",
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(modal.exit_mode("Scroll"), pane)
        window:perform_action(modal.activate_mode("search_mode"), pane)
      end),
    },
  },
}
