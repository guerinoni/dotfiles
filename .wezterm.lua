-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Dracula+'
config.font = wezterm.font 'Iosevka'
config.font_size = 13.0
config.keys = {
  {
    key = "k",
    mods = "CMD",
    action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
  },
  {
    key = "Enter",
    mods = "CMD|SHIFT",
    action = wezterm.action.SplitVertical,
  },
  {
    key = "Enter",
    mods = "CMD",
    action = wezterm.action.SplitHorizontal,
  },
  {
    key = "UpArrow",
    mods = "CMD",
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = "DownArrow",
    mods = "CMD",
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  {
    key = "LeftArrow",
    mods = "CMD",
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = "RightArrow",
    mods = "CMD",
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
}

-- and finally, return the configuration to wezterm
return config
