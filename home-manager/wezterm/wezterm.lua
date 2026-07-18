local wezterm = require("wezterm")
local act = wezterm.action

return {
	-- Theme
	color_scheme = "Dracula+",

	-- Font
	font = wezterm.font_with_fallback({
		{ family = "JetBrainsMono Nerd Font", weight = "Regular" },
		{
			family = "JetBrainsMono Nerd Font",
			weight = "Regular",
			assume_emoji_presentation = true,
		},
		{ family = "Noto Sans CJK JP" },
	}),
	font_size = 14.0,

	-- Padding
	window_padding = { left = 10, right = 10, top = 10, bottom = 10 },

	-- Tab
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	hide_tab_bar_if_only_one_tab = true,

	-- Misc
	use_ime = true, -- Enable IME
	check_for_updates = false, -- Disable update check
	audible_bell = "Disabled", -- Disable bell

	keys = {
		-- 全画面表示
		{ key = "n", mods = "SHIFT|CTRL", action = act.ToggleFullScreen },

		-- ペインを閉じる (herdr の Ctrl+a d と重複するバックアップ)
		{ key = "x", mods = "ALT", action = act.CloseCurrentPane({ confirm = true }) },

		-- 上記以外のタブ / ペインの操作は herdr に委譲する。
		-- WezTerm 側でキーを奪わないよう、対応するバインドは意図的に外して
		-- ある(そのままキーが herdr に渡る)。設定は home-manager/herdr/config.toml。
	},
}
