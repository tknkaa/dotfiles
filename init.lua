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
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", branch = "master", lazy = false },
	{ "nvim-telescope/telescope.nvim", tag = "0.1.8" },
	{ "neovim/nvim-lspconfig" },
	{ "nvim-lualine/lualine.nvim" },
	-- nvim-cmp and completion sources
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "nvim-tree/nvim-tree.lua" },
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

require("nvim-tree").setup()

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
map("i", "jk", "<ESC>", opts)
map("n", "<leader>f", ":Telescope find_files<CR>", opts)
map("n", "K", vim.lsp.buf.hover, opts)

map("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
map("n", "<leader>b", ":NvimTreeFocus<CR>", opts)

require("lualine").setup()
require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "lua", "python", "typescript", "tsx", "javascript", "svelte" },
	sync_install = false,
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
})

-- Setup nvim-cmp
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

-- Setup LSP servers with enhanced capabilities for autocompletion
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config.pyright = {
	capabilities = capabilities,
}
vim.lsp.config.clangd = {
	capabilities = capabilities,
}
vim.lsp.config.lua_ls = {
	capabilities = capabilities,
}
vim.lsp.config.ts_ls = {
	filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	capabilities = capabilities,
}
vim.lsp.config.svelte = {
	capabilities = capabilities,
}

vim.lsp.enable("pyright")
vim.lsp.enable("clangd")
vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("svelte")
