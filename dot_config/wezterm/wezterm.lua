-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'OneHalfDark'
  else
    return 'OneHalfLight'
  end
end

-- Handle different platforms
if wezterm.target_triple:find "windows" then
    config.default_prog = {"pwsh"}
end

-- changing the color scheme:
config.color_scheme = scheme_for_appearance(get_appearance())

-- configure the font with fallback
config.font = wezterm.font_with_fallback {
    'FiraCode Nerd Font',
    'Cascadia Code PL',
    'Menlo',
    'Monaco',
    'Courier New',
    'monospace',
}
-- change the font size
config.font_size = 14.0

-- and finally, return the configuration to wezterm
return config
