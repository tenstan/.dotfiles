return {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        'nvim-tree/nvim-web-devicons'
    },
    config = function ()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        local ignored_files = {
            '^\\.git'
        }

        require('nvim-tree').setup({
            -- Follow currently opened buffer
            update_focused_file = {
                enable = true
            },
            filters = {
                git_ignored = false,
                custom = ignored_files
            }
        })

        local api = require('nvim-tree.api')

        vim.keymap.set('n', '<leader>ne', api.tree.open)
        vim.keymap.set('n', '<leader>nt', function() api.tree.toggle({ focus = false }) end)
        vim.keymap.set('n', '<leader>nh', api.tree.toggle_help)
    end
}
