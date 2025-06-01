---@type LazySpec
return {
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
        },
        prompt_library = {
            ['Code Review'] = {
                strategy = 'chat',
                description = 'Perform a code review',
                opts = {
                    modes = { 'v' },
                },
                prompts = {
                    {
                        role = 'system',
                        content = [[
You are an expert code reviewer. You specialize in clean code practices, documentation, and performance optimizations.
Your goal is to help developers write clean, understandable, and efficient code through constructive feedback.

When asked to perform a code review, do so according to the following guidelines:

- Refactor inefficient or outdated code
- Suggest where documentation could be added or improved
- Improve unclear, misleading, inconsistent naming for variables, functions, or classes.
- Fix potential bugs or unhandled edge cases
- Improve overly complex logic and poor modularity/organization
- Fix inconsistent code conventions and formatting

Keep your feedback concise and only focus on what can be improved.
If a code change is required, then mention the original code, and then propose a code change to fix it along with a short description of why the change would be appropriate.
Lastly, provide a brief summary of your feedback at the end.
Use Markdown formatting to deliver your response.
                        ]],
                    },
                    {
                        role = 'user',
                        content = function(context)
                            local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                            return string.format(
                                [[Please review the following code:

```%s
%s
```
]],
                                context.filetype,
                                code
                            )
                        end,
                        opts = {
                            contains_code = true
                        }
                    }
                }
            },
            ['Rewrite Markdown'] = {
                strategy = 'chat',
                description = 'Rewrite Markdown documentation',
                opts = {
                    modes = { 'v' },
                },
                prompts = {
                    {
                        role = 'system',
                        content = [[
Act as a proofreading expert tasked with correcting errors in a given text.
Your job is to meticulously analyze the text, identify any grammatical mistakes, and make the necessary corrections to ensure clarity and accuracy.

When proofreading, follow these instructions:

- Suggest fixes for spelling or grammatical errors.
- Check for proper sentence structure, punctuation, verb tense consistency, and correct usage of words
- Follow a B2 language level; this means you should use simpler words. Do not make the text "wordy" and do not use overly formal expressions
- Do not change words like "print", "return", "concatenate", "function" or similar technical words when they are used in a technical context
- Ensure consistent naming for concepts such as systems, tools, applications or other technological concepts
- Make sure that common Markdown rules and conventions are followed
- Avoid contractions such as "I'm" or "You're"

Additionally, provide suggestions to enhance the readability and flow of the text.
The goal is to polish the text so that it communicates its message effectively and professionally.

If a section of the text can be improved, then mention a small portion of the section, and then propose a change to improve that portion of the section.
For each proposal, include a short description that explains why the change would be appropriate.
Lastly, provide a brief summary of your feedback at the end.
                        ]]
                    },
                    {
                        role = 'user',
                        content = function(context)
                            local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                            return string.format([['Please proofread and improve the following text:

```markdown
%s
```
]],
                                text
                            )
                        end
                    }
                }
            }
        }
    },
    keys = {
        { '<leader>ac', '<cmd>CodeCompanionChat<CR>',        mode = { 'n' },      desc = 'Start a new CodeCompanion chat' },
        { '<leader>at', '<cmd>CodeCompanionChat Toggle<CR>', mode = { 'n' },      desc = 'Toggle the CodeCompanion chat pane' },
        { '<leader>av', '<cmd>CodeCompanionChat Add<CR>',    mode = { 'v' },      desc = 'Add visually selected code to CodeCompanion chat' },
        { '<leader>aa', '<cmd>CodeCompanionActions<CR>',     mode = { 'n', 'v' }, desc = 'Open selection window to perform CodeCompanion action' }
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
