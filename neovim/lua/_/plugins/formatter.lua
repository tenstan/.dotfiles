---@type LazySpec
return {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    keys = {
        {
            '<leader>cc',
            function() require('conform').format({ async = true }) end,
            mode = { 'n', 'v' },
            desc = 'Format buffer',
        },
    },
    dependencies = {
        'mason-org/mason.nvim',
        'zapling/mason-conform.nvim',
    },
    config = function()
        local conform = require('conform')
        -- prettierd keeps a daemon around, which avoids prettier's slow cold start on every save
        local prettier = { 'prettierd', 'prettier', stop_after_first = true }

        conform.setup({
            formatters_by_ft = {
                javascript = prettier,
                javascriptreact = prettier,

                typescript = prettier,
                typescriptreact = prettier,

                svelte = prettier,

                css = prettier,
                scss = prettier,
                html = prettier,

                json = prettier,
                jsonc = prettier,
                yaml = prettier,

                markdown = prettier,

                c = { 'clang-format' },
                cpp = { 'clang-format' },
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

        require('mason-conform').setup()
    end
}
