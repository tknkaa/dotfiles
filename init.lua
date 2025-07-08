-- リーダーキーをスペースに設定
vim.g.mapleader = " "

-- インサートモードで 'jk' を押すとエスケープ（ノーマルモードに移行）
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', { noremap = true, silent = true })

-- ノーマルモードで <Space>E を押すとファイルエクスプローラーを開く
vim.api.nvim_set_keymap('n', '<leader>E', ':Explore<CR>', { noremap = true, silent = true })

vim.opt.clipboard:append({"unnamedplus"})
