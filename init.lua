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
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, 
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", branch = "master", lazy = false },
  { "nvim-telescope/telescope.nvim", tag = '0.1.8' },
  { "neovim/nvim-lspconfig" },
  { "nvim-lualine/lualine.nvim" },
})

vim.o.clipboard = "unnamedplus"
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
map("n", "K", vim.lsp.buf.hover, opts)

require("lualine").setup()
require("nvim-treesitter.configs").setup({
  ensure_installed = { "c", "lua", "python" },
  sync_install = false,
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
})

-- alr installed pyroght, clangd and lua-language-server from home-manager
vim.lsp.enable('pyright')
vim.lsp.enable('clangd')
vim.lsp.enable('lua_ls')
