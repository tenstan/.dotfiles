return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.7',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make'
        }
    },
    config = function()
        require('telescope').setup({
            defaults = {
                path_display = {
                    'filename_first',
                }
            }
        })
        require('telescope').load_extension('fzf')

        local builtin = require('telescope.builtin')

        local file_ignore_patterns = {
            "node_modules/",
            "dist/",
            "package%-lock%.json",
            "yarn%.lock",
            "%.git/"
        }

        vim.keymap.set('n', 'gd', builtin.lsp_definitions)
        vim.keymap.set('n', 'gt', builtin.lsp_type_definitions)
        vim.keymap.set('n', 'gi', builtin.lsp_implementations)
        vim.keymap.set('n', 'gr', builtin.lsp_references)
        vim.keymap.set('n', '<leader>fs', builtin.lsp_dynamic_workspace_symbols)

        vim.keymap.set('n', '<leader>xd', builtin.diagnostics)
        vim.keymap.set('n', '<leader>xq', builtin.quickfix)

        vim.keymap.set('n', '<leader>fr', builtin.resume)

        vim.keymap.set('n', 'ff', function()
            builtin.find_files {
                file_ignore_patterns = file_ignore_patterns,
                hidden = true,
                no_ignore = true
            }
        end)
        vim.keymap.set('n', '<leader>fF', function()
            builtin.find_files {
                hidden = true,
                no_ignore = true
            }
        end)
        vim.keymap.set('n', '<leader>fw', function ()
            builtin.live_grep {
                file_ignore_patterns = file_ignore_patterns,
                additional_args = function()
                    return { '--hidden' }
                end
            }
        end)
        vim.keymap.set('n', '<leader>fW', function()
            builtin.live_grep {
                additional_args = function ()
                   return { '--hidden', '--no-ignore' }
                end
            }
        end)
    end
}
