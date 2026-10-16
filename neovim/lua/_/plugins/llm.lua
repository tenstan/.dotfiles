---@type LazySpec
return {
    {
        'olimorris/codecompanion.nvim',
        version = '>=19.27.0 <20.0.0',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
            'zbirenbaum/copilot.lua',
            'j-hui/fidget.nvim',
            'lalitmee/codecompanion-spinners.nvim',
            'sindrets/diffview.nvim',
        },
        opts = {
            extensions = {
                spinner = {
                    opts = { style = 'fidget' },
                },
            },
            interactions = {
                chat = {
                    adapter = 'opencode',
                    tools = {
                        opts = { approval_mode = 'ask' },
                    },
                },
                inline = { adapter = 'copilot' },
            },
            adapters = {
                acp = {
                    opts = { show_presets = false },
                    opencode = function()
                        return require('codecompanion.adapters').extend('opencode', {})
                    end,
                },
                http = {
                    opts = { show_presets = false },
                    copilot = 'copilot', -- Use the provider's default; choose models with ga.
                },
            },
            display = {
                action_palette = {
                    opts = {
                        show_preset_prompts = false,
                    },
                },
                chat = {
                    window = { layout = 'vertical', position = 'right', width = 0.4 },
                },
                diff = { enabled = true },
            },
        },
        keys = {
            { '<leader>at', '<cmd>CodeCompanionChat Toggle<CR>', mode = { 'n', 'x' }, desc = 'AI: toggle agent chat' },
            { '<leader>ac', '<cmd>CodeCompanionChat<CR>', desc = 'AI: new agent chat' },
            { '<leader>aa', '<cmd>CodeCompanionActions<CR>', mode = { 'n', 'x' }, desc = 'AI: actions' },
            { '<leader>ar', '<cmd>DiffviewOpen refs/worktree/codecompanion/baseline<CR>', desc = 'AI: review agent changes' },
            {
                '<leader>ab',
                function()
                    local root = vim.fs.root(0, '.git') or vim.fn.getcwd()
                    local baseline = require('codecompanion.interactions.code_review.baseline')
                    local fork_point = baseline.fork_point(root)
                    if not fork_point then
                        vim.notify('Could not find the branch fork point', vim.log.levels.WARN)
                        return
                    end
                    vim.cmd('DiffviewOpen ' .. fork_point)
                end,
                desc = 'AI: review branch changes',
            },
            { '<leader>af', '<cmd>CodeCompanionCodeReview Comment<CR>', mode = { 'n', 'x' }, desc = 'AI: leave review feedback' },
        },
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = { 'codecompanion' },
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        ---@module 'render-markdown'
        opts = {
            file_types = { 'codecompanion' },
            -- Keep responses rendered while typing a prompt.
            render_modes = true,
        },
    },
    {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        opts = {
            panel = { enabled = false },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                hide_during_completion = false,
                keymap = {
                    accept = '<C-l>',
                    accept_word = false,
                    accept_line = false,
                    next = false,
                    prev = false,
                    dismiss = '<C-]>',
                },
            },
            filetypes = { codecompanion = false },
        },
    },
}
