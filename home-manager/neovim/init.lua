-- To add a new LSP, edit the following 3 places:
-- 1. vim.lsp.config.*: per-LSP settings like capabilities
-- 2, vim.lsp.enable(): list of enabled servers
-- 3. extraPackages: install the binary via nix (./default.nix)
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
		"cordx56/rustowl",
		version = "*",
		lazy = false,
		opts = {},
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

			vim.lsp.config.pyright = { capabilities = capabilities }
			vim.lsp.config.clangd = { capabilities = capabilities }
			vim.lsp.config.lua_ls = { capabilities = capabilities }
			vim.lsp.config.svelte = { capabilities = capabilities }
			vim.lsp.config.gopls = { capabilities = capabilities }
			vim.lsp.config.r_language_server = { capabilities = capabilities }
			vim.lsp.config.nixd = { capabilities = capabilities }
			vim.lsp.config.gleam = { capabilities = capabilities }
			vim.lsp.config.rust_analyzer = { capabilities = capabilities }
			vim.lsp.config.tinymist = { capabilities = capabilities }

			vim.lsp.config.ts_ls = {
				capabilities = capabilities,
				filetypes = {
					"typescript",
					"typescriptreact",
					"javascript",
					"javascriptreact",
				},
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

			vim.lsp.enable({
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
			})
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

vim.lsp.set_log_level("off")

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>o", function()
  require("rustowl").toggle()
end, { desc = "RustOwl Toggle" })

map("i", "jk", "<ESC>", opts)
map("n", "<leader>f", ":Telescope find_files<CR>", opts)
map("n", "K", vim.lsp.buf.hover, opts)
map("n", "<C-k>", vim.diagnostic.open_float, opts)
map("n", "[d", vim.diagnostic.goto_prev, opts)
map("n", "]d", vim.diagnostic.goto_next, opts)
map("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
map("n", "<leader>b", ":NvimTreeFocus<CR>", opts)
