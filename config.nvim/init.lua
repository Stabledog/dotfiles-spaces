#-- Neovim configuration file for lmatheson4
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })
vim.o.timeoutlen = 300
vim.keymap.set('n', 'p', '"+p', { noremap = true, silent = true })
vim.keymap.set('n', 'P', '"+P', { noremap = true, silent = true })

