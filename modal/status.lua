local w = require("wezterm")

---@alias ColorSet {fg: string, bg: string}
---@alias ColorConfig {dressing: ColorSet, keys: ColorSet|nil, hint: ColorSet, mode: ColorSet}
---@alias Hint {mods: string?, keys: string, desc: string? }

local function _fg(color)
  return { Foreground = { Color = color } }
end

local function _bg(color)
  return { Background = { Color = color } }
end

---@param colors ColorSet
---@param text string
---@return string
local function _text(colors, text)
  return text and w.format({
    _bg(colors.bg),
    _fg(colors.fg),
    { Text = text },
  }) or ""
end

local function _mod(mods, after_mod)
  return mods and mods .. (after_mod or "") or ""
end

local function _status(dressing, colors, mode_name)
  local c = colors.mode or colors.dressing
  return _text(colors.dressing, dressing.left) .. _text(c, mode_name)
end

---@param dressing {left: string, right: string}
---@param colors ColorConfig
---@param separators {after_mods: string|nil, after_keys: string|nil}
---@param hint_content Hint
local function hint(dressing, colors, separators, hint_content)
  return _text(colors.dressing, dressing.left)
    .. _text(colors.keys or colors.dressing, _mod(hint_content.mods, separators.after_mods) .. hint_content.keys)
    .. _text(colors.dressing, (separators.after_keys or ""))
    .. _text(colors.hint, hint_content[1])
    .. _text(colors.dressing, dressing.right)
end

---@param mode_name string
---@param dressing {left: string, right: string}
---@param colors ColorConfig
---@param separators {after_mods: string|nil, after_keys: string|nil}
---@param hints Hint[]
local function status_line(mode_name, dressing, colors, separators, hints)
  local status = ""
  for _, thisHint in ipairs(hints) do
    status = status .. hint(dressing, colors, separators, thisHint)
  end
  status = status .. _status(dressing, colors, mode_name)
  return status
end

local function status_line_defaults(cfg, accent_color)
  local bg = cfg.colors.tab_bar.background or cfg.colors.background
  return {
    dressing = { left = "\u{e0b6}", right = "" },
    colors = {
      dressing = { fg = accent_color, bg = bg },
      keys = { fg = bg, bg = accent_color },
      hint = { fg = cfg.colors.foreground, bg = bg },
      mode = { fg = bg, bg = accent_color },
    },
    separators = { after_mods = "+", after_keys = " " },
  }
end

return {
  hint = hint,
  status_line = status_line,
  status_line_defaults = status_line_defaults,
}
