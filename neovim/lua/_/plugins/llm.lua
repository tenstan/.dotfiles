---@type LazySpec
return {
    -- Current issues:
    -- * When using the /file slash command in the chat window, Telescope opens with parantheses filled in by default. This is annoying as you need to clear the parantheses to search files.
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
            openai = function()
                return require('codecompanion.adapters').extend('openai', {
                    env = {
                        api_key = os.getenv('OPENAI_API_KEY')
                    }
                })
            end
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
