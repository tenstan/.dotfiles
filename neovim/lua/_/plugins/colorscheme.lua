return {
    {
        'dasupradyumna/midnight.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd('colorscheme midnight')
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons'
        },
        config = function()
            require('lualine').setup({
                options = {
                    theme = {
                        normal = {
                            a = { fg = '#080c10', bg = '#78a9ff', gui = 'bold' },
                            b = { fg = '#b5bdc5', bg = '#262626' },
                            c = { fg = '#b5bdc5', bg = '#080c10' },
                        },
                        insert = {
                            a = { fg = '#080c10', bg = '#42be65', gui = 'bold' },
                            b = { fg = '#b5bdc5', bg = '#262626' },
                            c = { fg = '#b5bdc5', bg = '#080c10' },
                        },
                        visual = {
                            a = { fg = '#080c10', bg = '#a56eff', gui = 'bold' },
                            b = { fg = '#b5bdc5', bg = '#262626' },
                            c = { fg = '#b5bdc5', bg = '#080c10' },
                        },
                        replace = {
                            a = { fg = '#080c10', bg = '#fa4d56', gui = 'bold' },
                            b = { fg = '#b5bdc5', bg = '#262626' },
                            c = { fg = '#b5bdc5', bg = '#080c10' },
                        },
                        command = {
                            a = { fg = '#080c10', bg = '#ff832b', gui = 'bold' },
                            b = { fg = '#b5bdc5', bg = '#262626' },
                            c = { fg = '#b5bdc5', bg = '#080c10' },
                        },
                        inactive = {
                            a = { fg = '#b5bdc5', bg = '#262626', gui = 'bold' },
                            b = { fg = '#b5bdc5', bg = '#181818' },
                            c = { fg = '#b5bdc5', bg = '#080c10' },
                        },
                    },
                    component_separators = '|',
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff' },
                    lualine_c = { 'diagnostics', 'filename' },
                    lualine_x = { 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' },
                },
                extensions = {
                    'oil'
                }
            })
        end
    },
}
