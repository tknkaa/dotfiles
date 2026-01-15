local wezterm = require("wezterm")
local act = wezterm.action

return {
    -- Theme
    color_scheme = "Dracula+",

    -- Font
    font = wezterm.font_with_fallback({
        {family = "JetBrainsMono Nerd Font", weight = "Regular"}, {
            family = "JetBrainsMono Nerd Font",
            weight = "Regular",
            assume_emoji_presentation = true
        }, {family = "Noto Sans CJK JP"}
    }),
    font_size = 14.0,

    -- Padding
    window_padding = {left = 10, right = 10, top = 10, bottom = 10},

    -- Tab
    use_fancy_tab_bar = false,
    tab_bar_at_bottom = true,
    hide_tab_bar_if_only_one_tab = true,

    -- Misc
    use_ime = true, -- Enable IME
    check_for_updates = false, -- Disable update check
    audible_bell = "Disabled", -- Disable bell

    keys = {
        -- 1. 全画面表示 (既存の設定)
        {key = "n", mods = "SHIFT|CTRL", action = act.ToggleFullScreen},

        -- 2. タブの操作
        {key = "t", mods = "SHIFT|CTRL", action = act.SpawnTab("DefaultDomain")}, -- タブ追加
        {
            key = "w",
            mods = "SHIFT|CTRL",
            action = act.CloseCurrentTab({confirm = true})
        }, -- タブを閉じる
        {key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1)}, -- 次のタブへ (Ctrl + Tab)
        {key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1)}, -- 前のタブへ (Ctrl + Shift + Tab)

        -- 3. ペインの分割 (縦に分割 / 横に分割)
        {
            key = "v",
            mods = "ALT",
            action = act.SplitHorizontal({domain = "CurrentPaneDomain"})
        }, -- 垂直に割る(右に開く)
        {
            key = "s",
            mods = "ALT",
            action = act.SplitVertical({domain = "CurrentPaneDomain"})
        }, -- 水平に割る(下に開く)
        -- 4. ペインの移動 (矢印キーで移動)
        {key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left")},
        {key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right")},
        {key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up")},
        {key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down")},

        -- 5. ペインを閉じる
        {
            key = "x",
            mods = "ALT",
            action = act.CloseCurrentPane({confirm = true})
        }
    }
}
