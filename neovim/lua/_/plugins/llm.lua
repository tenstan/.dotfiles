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
        {
            'MeanderingProgrammer/render-markdown.nvim',
            ft = { 'codecompanion', 'markdown' },
            config = function()
                require('render-markdown').setup({
                    heading = {
                        width = 'block',
                        backgrounds = {
                            'RenderMarkdownH1Bg',
                            'RenderMarkdownH2Bg',
                            'RenderMarkdownH3Bg',
                            'RenderMarkdownH4Bg',
                            'RenderMarkdownH5Bg',
                            'RenderMarkdownH6Bg',
                        },
                        foregrounds = {
                            'RenderMarkdownH1',
                            'RenderMarkdownH2',
                            'RenderMarkdownH3',
                            'RenderMarkdownH4',
                            'RenderMarkdownH5',
                            'RenderMarkdownH6',
                        },
                    },
                    code = {
                        -- Highlight for code blocks.
                        highlight = 'RenderMarkdownCode',
                        -- Highlight for border, use false to add no highlight.
                        highlight_border = 'RenderMarkdownCodeBorder',
                        -- Highlight for inline code.
                        highlight_inline = 'RenderMarkdownCodeInline',
                    },
                    bullet = {
                        enabled = false,
                    },
                    pipe_table = {
                        preset = 'double',
                        -- Highlight for table heading, delimiter, and the line above.
                        head = 'RenderMarkdownTableHead',
                        -- Highlight for everything else, main table rows and the line below.
                        row = 'RenderMarkdownTableRow',
                        -- Highlight for inline padding used to add back concealed space.
                        filler = 'RenderMarkdownTableFill',
                    },
                })

                vim.api.nvim_set_hl(0, 'RenderMarkdownH1', { fg = '#78a9ff' })
                vim.api.nvim_set_hl(0, '@markup.heading.1.markdown', { fg = '#78a9ff' })
                vim.api.nvim_set_hl(0, 'RenderMarkdownH1Bg', { bg = '#080c10' })

                vim.api.nvim_set_hl(0, 'RenderMarkdownH2', { fg = '#6fdc8c' })
                vim.api.nvim_set_hl(0, '@markup.heading.2.markdown', { fg = '#6fdc8c' })
                vim.api.nvim_set_hl(0, 'RenderMarkdownH2Bg', { bg = '#080c10' })

                vim.api.nvim_set_hl(0, 'RenderMarkdownH3', { fg = '#fa4d56' })
                vim.api.nvim_set_hl(0, '@markup.heading.3.markdown', { fg = '#fa4d56' })
                vim.api.nvim_set_hl(0, 'RenderMarkdownH3Bg', { bg = '#080c10' })

                vim.api.nvim_set_hl(0, 'RenderMarkdownH4', { fg = '#a56eff' })
                vim.api.nvim_set_hl(0, '@markup.heading.4.markdown', { fg = '#a56eff' })
                vim.api.nvim_set_hl(0, 'RenderMarkdownH4Bg', { bg = '#080c10' })

                vim.api.nvim_set_hl(0, 'RenderMarkdownH5', { fg = '#009d9a' })
                vim.api.nvim_set_hl(0, '@markup.heading.5.markdown', { fg = '#009d9a' })
                vim.api.nvim_set_hl(0, 'RenderMarkdownH5Bg', { bg = '#080c10' })

                vim.api.nvim_set_hl(0, 'RenderMarkdownH6', { fg = '#ff9d57' })
                vim.api.nvim_set_hl(0, '@markup.heading.6.markdown', { fg = '#ff9d57' })
                vim.api.nvim_set_hl(0, 'RenderMarkdownH6Bg', { bg = '#080c10' })

                vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = '#161616' })
                vim.api.nvim_set_hl(0, 'RenderMarkdownCodeBorder', { fg = '#ff7eb6', bg = '#161616', italic = true })
            end,
        },
    },
}
