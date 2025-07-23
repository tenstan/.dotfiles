---@type LazySpec
return {
    'stevearc/conform.nvim',
    dependencies = {
        'mason-org/mason.nvim',
        'zapling/mason-conform.nvim',
    },
    config = function()
        require('mason').setup()

        local conform = require('conform')
        conform.setup({
            formatters_by_ft = {
                javascript = { 'prettier' },
                jsx = { 'prettier' },
                javascriptreact = { 'prettier' },

                typescript = { 'prettier' },
                tsx = { 'prettier' },
                typescriptreact = { 'prettier' },

                vue = { 'prettier' },

                markdown = { 'prettier' },

                cpp = { 'clang-format' }
            },

            default_format_opts = {
                lsp_format = 'fallback',
            },

            -- Only format on save when a formatter has been explicitly configured and a config file for it was found
            format_on_save = function(bufnr)
                local attached_formatters = conform.list_formatters(bufnr)


                for _, formatter in ipairs(attached_formatters) do
                    local config = conform.get_formatter_config(formatter.name, bufnr)

                    if config and config.cwd then
                        local ctx = require("conform.runner").build_context(bufnr, config)
                        ---@cast config conform.JobFormatterConfig
                        local cwd = config.cwd(config, ctx)

                        if cwd then
                            return { timeout_ms = 500, }
                        end
                    end
                end
            end
        })

        vim.keymap.set({ 'n', 'v' }, '<leader>cc', function()
            conform.format({ async = true, })
        end)

        require('mason-conform').setup()
    end
}
