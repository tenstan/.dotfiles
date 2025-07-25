---@type LazySpec
return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects'
    },
    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = {
                'bash',
                'bicep',
                'c_sharp',
                'cpp',
                'css',
                'dockerfile',
                'html',
                'http',
                'javascript',
                'jsdoc',
                'json',
                'lua',
                'markdown',
                'markdown_inline',
                'sql',
                'svelte',
                'tsx',
                'typescript',
                'yaml'
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            auto_install = true,

            -- Indentation based on treesitter for the = operator. NOTE: This is an experimental feature
            indent = {
                enable = true
            },

            -- List of parsers to ignore installing
            ignore_install = {},

            -- Consistent syntax highlighting
            highlight = {
                enable = true,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = { 'markdown' },
            },

            modules = {},

            -- Set mappings for treesitter motions
            textobjects = {
                -- Visually select with treesitter context
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ['im'] = '@function.inner',
                        ['am'] = '@function.outer',
                        ['ic'] = '@class.inner',
                        ['ac'] = '@class.outer',
                        ['a='] = '@assignment.outer',
                        ['l='] = '@assignment.lhs',
                        ['r='] = '@assignment.rhs',
                    }
                },
                -- Move between items with treesitter context
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        [']m'] = '@function.outer',
                        [']c'] = '@class.outer'
                    },
                    goto_previous_start = {
                        ['[m'] = '@function.outer',
                        ['[c'] = '@class.outer',
                    }
                }
            }
        })

        local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')

        vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
        vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

        vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
    end
}
