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
            formatters = {
                prettier = {
                    -- Only perform prettier formatting when a prettier config is detected within the project by conform.nvim
                    require_cwd = true
                }
            },

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

            format_on_save = function(bufnr)
                -- Only format on save when a formatter has been explicitly configured (so don't use a LSP formatter as fallback).
                local attached_formatters = require("conform").list_formatters(bufnr)
                if (vim.tbl_count(attached_formatters) > 0) then
                    return { timeout_ms = 500, }
                end
            end
        })

        vim.keymap.set({ 'n', 'v' }, '<leader>cc', function()
            conform.format({ async = true, })
        end)

        require('mason-conform').setup()
    end
}
