---@type LazySpec
return {
    -- Current issues:
    -- * The /symbols slash command does not seem to work. Files don't get added as context when you select them in Telescope.
    'olimorris/codecompanion.nvim',
    event = 'VeryLazy',
    opts = {
        strategies = {
            chat = {
                adapter = 'copilot'
            }
        },
        adapters = {
            opts = {
                show_defaults = false,
            },
            copilot = function()
                return require('codecompanion.adapters').extend('copilot', {
                    schema = {
                        model = {
                            default = 'claude-3.7-sonnet'
                        }
                    }
                })
            end,
        },
        display = {
            chat = {
                window = {
                    position = 'right'
                }
            }
        }
    },
    keys = {
        { '<leader>ac', '<cmd>CodeCompanionChat<CR>',        mode = { 'n' }, desc = 'Start a new CodeCompanion chat' },
        { '<leader>at', '<cmd>CodeCompanionChat Toggle<CR>', mode = { 'n' }, desc = 'Toggle the CodeCompanion chat pane' },
        { '<leader>av', '<cmd>CodeCompanionChat Add<CR>',    mode = { 'v' }, desc = 'Add visually selected code to CodeCompanion chat' },
    },
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        {
            'zbirenbaum/copilot.lua',
            ---@module 'copilot'
            ---@type CopilotConfig
            ---@diagnostic disable-next-line: missing-fields
            opts = {
                ---@diagnostic disable-next-line: missing-fields
                panel = {
                    enabled = false,
                },
                ---@diagnostic disable-next-line: missing-fields
                suggestion = {
                    enabled = false,
                },
            }
        },
    },
}
