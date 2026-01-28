vim.g.mapleader = " " -- Set the leader key to spacebar for custom key mappings
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "Mofiqul/dracula.nvim",
        lazy = false,
        priority = 1000,
        config = function() vim.cmd([[colorscheme dracula]]) end
    }, {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        branch = "master",
        lazy = false
    }, {"nvim-telescope/telescope.nvim", tag = "0.1.8"},
    {"neovim/nvim-lspconfig"}, {"nvim-lualine/lualine.nvim"},
    {"hrsh7th/nvim-cmp"}, {"hrsh7th/cmp-nvim-lsp"}, {"hrsh7th/cmp-buffer"},
    {"hrsh7th/cmp-path"}, {"nvim-tree/nvim-tree.lua"},
    {"windwp/nvim-autopairs", event = "InsertEnter", config = true}
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

local map = vim.keymap.set -- shortcut for keymap.set
local opts = {noremap = true, silent = true}
map("i", "jk", "<ESC>", opts) -- shortcut: 'jk' in insert mode to escape
map("n", "<leader>f", ":Telescope find_files<CR>", opts) -- shortcut: <Space>f to Telescope file finder
map("n", "K", vim.lsp.buf.hover, opts) -- shortcut: 'K' for LSP hover
map("n", "<C-k>", vim.diagnostic.open_float, opts) -- shortcut: Ctrl+K to show diagnostics/errors
map("n", "[d", vim.diagnostic.goto_prev, opts) -- shortcut: '[d' to go to previous diagnostic
map("n", "]d", vim.diagnostic.goto_next, opts) -- shortcut: ']d' to go to next diagnostic

map("n", "<leader>e", ":NvimTreeToggle<CR>", opts) -- shortcut: <Space>e to toggle nvim-tree
map("n", "<leader>b", ":NvimTreeFocus<CR>", opts) -- shortcut: <Space>b to focus nvim-tree

require("lualine").setup()
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "c", "lua", "python", "typescript", "tsx", "javascript", "svelte", "gleam",
        "go", "r", "nix"
    },
    sync_install = false,
    auto_install = true,
    highlight = {enable = true},
    indent = {enable = true}
})

local cmp = require("cmp")
cmp.setup({
    mapping = cmp.mapping.preset.insert({ -- shortcut for completion menu
        ["<C-Space>"] = cmp.mapping.complete(), -- shortcut: Ctrl+Space to trigger completion
        ["<C-e>"] = cmp.mapping.abort(), -- shortcut: Ctrl+e to abort completion
        ["<CR>"] = cmp.mapping.confirm({select = true}), -- shortcut: Enter to confirm completion
        ["<Tab>"] = cmp.mapping.select_next_item(), -- shortcut: Tab to next completion
        ["<S-Tab>"] = cmp.mapping.select_prev_item() -- shortcut: Shift+Tab to previous completion
    }),
    sources = cmp.config.sources({
        {name = "nvim_lsp"}, {name = "buffer"}, {name = "path"}
    })
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config.pyright = {capabilities = capabilities}
vim.lsp.config.clangd = {capabilities = capabilities}
vim.lsp.config.gopls = {capabilities = capabilities}
vim.lsp.config.lua_ls = {capabilities = capabilities}
vim.lsp.config.ts_ls = {
    filetypes = {
        "typescript", "typescriptreact", "javascript", "javascriptreact"
    },
    capabilities = capabilities
}
vim.lsp.config.svelte = {capabilities = capabilities}
vim.lsp.config.r_language_server = {capabilities = capabilities}
vim.lsp.config.nixd = {capabilities = capabilities}
vim.lsp.config.gleam = {capabilities = capabilities}

vim.lsp.enable("pyright")
vim.lsp.enable("clangd")
vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("svelte")
vim.lsp.enable("gopls")
vim.lsp.enable("r_language_server")
vim.lsp.enable("nixd")
vim.lsp.enable("gleam")
