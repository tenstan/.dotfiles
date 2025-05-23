vim.g.mapleader = ' '

-- Keep cursor on the center of the screen when hopping
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- For inserting empty lines without entering insert mode
vim.keymap.set('n', '<leader>o', 'o<Esc>k')
vim.keymap.set('n', '<leader>O', 'O<Esc>j')

-- Copy to system clipboard
vim.keymap.set({'n', 'v'}, '<leader>y', [["+y]])

-- Delete to black hole register
vim.keymap.set({'n', 'v'}, '<leader>d', [["_d]])

-- Paste from clipboard
vim.keymap.set({'n', 'v'}, '<leader>p', [["+p]])

-- Close all panes except currently focused one
vim.keymap.set('n', '<leader>;', '<cmd>only<CR>')

vim.keymap.set('n', '<leader>ee', function() vim.diagnostic.open_float() end)
