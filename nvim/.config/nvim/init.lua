-- To add a new LSP, edit the following 3 places:
-- 1. vim.lsp.config.*: per-LSP settings like capabilities
-- 2. vim.lsp.enable(): list of enabled servers
-- 3. install the binary: add it to mason-lspconfig's ensure_installed, or
--    install it with dnf/rustup (clangd, gopls, rust_analyzer) via install.sh
vim.g.mapleader = " "
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("vscode").setup({
				transparent = false,
				italic_comments = true,
				disable_nvimtree_bg = true,
			})
			vim.cmd([[colorscheme vscode]])
		end,
	},
	{
		"yorickpeterse/vim-paper",
		lazy = true,
	},
	{
		"github/copilot.vim",
		config = function()
			vim.g.copilot_no_tab_map = true
			vim.keymap.set("i", "<C-j>", 'copilot#Accept("")', {
				expr = true,
				replace_keycodes = false,
				silent = true,
			})
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			"github/copilot.vim",
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>cc", "<cmd>CopilotChat<CR>", desc = "CopilotChat" },
			{ "<leader>ce", "<cmd>CopilotChatExplain<CR>", desc = "Explain code" },
			{ "<leader>cf", "<cmd>CopilotChatFix<CR>", desc = "Fix code" },
			{ "<leader>ct", "<cmd>CopilotChatTests<CR>", desc = "Generate tests" },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "main",
		lazy = false,
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = {
					"c",
					"lua",
					"python",
					"typescript",
					"tsx",
					"javascript",
					"svelte",
					"gleam",
					"go",
					"r",
					"rust",
					"typst",
					"vue",
				},
				sync_install = false,
				auto_install = true,
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					preview = {
						treesitter = false,
					},
				},
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
			},
			current_line_blame = true,
		},
	},
	-- 差分を見ながら編集するためのインライン表示。普段は行番号の色だけにして通常の見た目を保ち、必要なときだけオーバーレイを出す
	{
		"nvim-mini/mini.diff",
		version = "*",
		event = "VeryLazy",
		config = function()
			local diff = require("mini.diff")
			diff.setup({
				view = { style = "number" },
				-- hunk の移動や stage は gitsigns の ]c / <leader>h* に揃えるため、mini.diff 側のキーは割り当てない。二重に定義すると挙動が紛らわしくなる
				mappings = {
					apply = "",
					reset = "",
					textobject = "",
					goto_first = "",
					goto_prev = "",
					goto_next = "",
					goto_last = "",
				},
			})
			vim.keymap.set("n", "<leader>gd", diff.toggle_overlay, { desc = "差分オーバーレイ切替" })

			-- 既定では変更行の新しい側も DiffText に紐づき、vscode テーマだと赤になる。追加した文字まで赤いと削除と見分けられないので、新しい側は DiffAdd の緑にする
			local function set_diff_hl()
				vim.api.nvim_set_hl(0, "MiniDiffOverChangeBuf", { link = "DiffAdd" })
			end
			set_diff_hl()
			-- カラースキームを切り替えるとハイライトが初期化されるため、そのたびに設定し直す
			vim.api.nvim_create_autocmd("ColorScheme", { callback = set_diff_hl })
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		opts = {
			-- Servers not available from dnf/rustup. Enabled below via vim.lsp.enable().
			ensure_installed = {
				"lua_ls",
				"pyright",
				"ts_ls",
				"svelte",
				"vue_ls",
				"tinymist",
				"terraformls",
			},
			automatic_enable = false,
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.lsp.config.pyright = { capabilities = capabilities }
			vim.lsp.config.clangd = { capabilities = capabilities }
			vim.lsp.config.lua_ls = { capabilities = capabilities }
			vim.lsp.config.svelte = { capabilities = capabilities }
			vim.lsp.config.gopls = { capabilities = capabilities }
			vim.lsp.config.r_language_server = { capabilities = capabilities }
			vim.lsp.config.gleam = { capabilities = capabilities }
			vim.lsp.config.rust_analyzer = { capabilities = capabilities }
			vim.lsp.config.tinymist = { capabilities = capabilities }
			vim.lsp.config.vue_ls = { capabilities = capabilities }
			vim.lsp.config.terraformls = { capabilities = capabilities }

			vim.lsp.config.ts_ls = {
				capabilities = capabilities,
				filetypes = {
					"typescript",
					"typescriptreact",
					"javascript",
					"javascriptreact",
				},
			}

			vim.filetype.add({
				extension = {
					tf = "terraform",
				},
			})
			vim.lsp.enable({
				"pyright",
				"clangd",
				"lua_ls",
				"ts_ls",
				"svelte",
				"gopls",
				"r_language_server",
				"gleam",
				"rust_analyzer",
				"tinymist",
				"vue_ls",
				"terraformls",
			})
		end,
	},
	-- Lean の LSP は lake 経由でプロジェクトごとの toolchain を使う必要があるため、lspconfig ではなく lean.nvim に任せる
	{
		"Julian/lean.nvim",
		event = { "BufReadPre *.lean", "BufNewFile *.lean" },
		-- 現行版は setup() を持たず vim.g.lean_config を読むため、opts ではなく init で渡す。opts だと読み込み時にエラーになる
		init = function()
			vim.g.lean_config = { mappings = true }
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup()
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup()
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
})

vim.o.clipboard = "unnamedplus"
vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.cursorline = true

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

vim.lsp.log.set_level("off")

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("i", "jk", "<ESC>", opts)
map("n", "<leader>f", ":Telescope find_files<CR>", opts)
map("n", "K", vim.lsp.buf.hover, opts)
map("n", "<C-k>", vim.diagnostic.open_float, opts)
map("n", "[d", vim.diagnostic.goto_prev, opts)
map("n", "]d", vim.diagnostic.goto_next, opts)
map("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
map("n", "<leader>b", ":NvimTreeFocus<CR>", opts)
map("n", "]c", ":Gitsigns next_hunk<CR>", opts)
map("n", "[c", ":Gitsigns prev_hunk<CR>", opts)
map("n", "<leader>hp", ":Gitsigns preview_hunk<CR>", opts)
map("n", "<leader>hs", ":Gitsigns stage_hunk<CR>", opts)
map("n", "<leader>hr", ":Gitsigns reset_hunk<CR>", opts)
map("n", "gd", vim.lsp.buf.definition, opts)
map("n", "gr", vim.lsp.buf.references, opts)
-- ウィンドウ操作の割り当てを herdr のペイン操作(prefix+d で閉じる、prefix+n でズーム)に揃え、両方で同じ指の動きにするため。
-- 既定の <C-w>d(診断の表示)は <C-k> と同じなので上書きしてよい
map("n", "<C-w>d", "<cmd>close<CR>", opts)
map("n", "<C-w>n", function()
	-- ズーム中に戻すと元の配置に戻れるよう、ズーム前の配置を覚えておく。そうしないと <C-w>= で均等割りにしか戻らない
	if vim.t.zoom_restore then
		vim.cmd(vim.t.zoom_restore)
		vim.t.zoom_restore = nil
	else
		vim.t.zoom_restore = vim.fn.winrestcmd()
		vim.cmd("wincmd | | wincmd _")
	end
end, opts)
map("n", "gi", vim.lsp.buf.implementation, opts)
