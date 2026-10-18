pcall(vim.cmd.language, 'en_US')

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.showmode = false -- lualine already shows the mode

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.updatetime = 250
vim.o.winborder = 'rounded'

vim.opt.colorcolumn = table.concat(vim.fn.range(160, 999), ',')

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath('data') .. '/undodir'
vim.opt.undofile = true

vim.diagnostic.config({ virtual_text = true, severity_sort = true })
