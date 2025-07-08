-- wezterm.lua の中身

local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

-- これ以降に設定を記述

config.keys = {
  -- Vキーで左右分割 (Vertical)
  {
    key = 'V',
    mods = 'CTRL|SHIFT',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  -- Hキーで上下分割 (Horizontal)
  {
    key = 'H',
    mods = 'CTRL|SHIFT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },

  -- Ctrl + Shift + 矢印キーでペインを移動
  { key = 'LeftArrow',  mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow',  mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Down' },
}

return config
