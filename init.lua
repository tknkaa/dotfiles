vim.g.mapleader = " "

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
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "neovim/nvim-lspconfig" },
  { "nvim-lualine/lualine.nvim" },
})

vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.cursorline = true

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
map("i", "jk", "<ESC>", opts)
map("n", "<leader>e", ":Explore<CR>", opts)
map("n", "<leader>f", ":Telescope find_files<CR>", opts)

require("lualine").setup()
require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  indent = { enable = true },
})
