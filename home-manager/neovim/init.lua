vim.g.mapleader = " " -- Set the leader key to spacebar for custom key mappings
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

-- LSPサーバーリスト
local lsp_servers = {
	"pyright",
	"clangd",
	"lua_ls",
	"ts_ls",
	"svelte",
	"gopls",
	"r_language_server",
	"nixd",
	"gleam",
	"rust_analyzer",
	"tinymist",
	"zls",
}

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
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "master",
		lazy = false,
		config = function()
			require("nvim-treesitter.configs").setup({
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
					"nix",
					"rust",
					"typst",
					"zig",
				},
				sync_install = false,
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- すべてのLSPに共通の設定
			for _, server in ipairs(lsp_servers) do
				vim.lsp.config[server] = {
					capabilities = capabilities,
				}
			end

			-- TypeScript固有の設定
			vim.lsp.config.ts_ls = {
				filetypes = {
					"typescript",
					"typescriptreact",
					"javascript",
					"javascriptreact",
				},
				capabilities = capabilities,
			}

      vim.lsp.config.zls = {
        capabilities = capabilities,
        settings = {
          zls = {
            enable_build_on_save = true,
            build_on_save_step = "check",
          },
        },
      }

			-- LSPを有効化
			for _, server in ipairs(lsp_servers) do
				vim.lsp.enable(server)
			end
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

-- 基本設定
vim.o.clipboard = "unnamedplus"
vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.cursorline = true
-- To switch to light theme, run: :colorscheme paper

-- キーマップ設定
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
