return {
    'stevearc/conform.nvim',
    dependencies = {
        'williamboman/mason.nvim',
        'zapling/mason-conform.nvim',
    },
    config = function()
        require('mason').setup()

        local conform = require('conform')
        conform.setup({
            formatters_by_ft = {
                javascript = { 'prettierd' },
                jsx = { 'prettierd' },
                javascriptreact = { 'prettierd' },

                typescript = { 'prettierd' },
                tsx = { 'prettierd' },
                typescriptreact = { 'prettierd' },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_format = 'fallback',
            }
        })

        vim.api.nvim_create_autocmd('BufWritePre', {
            pattern = '*',
            callback = function(args)
                conform.format({ bufnr = args.buf })
            end
        })

        vim.keymap.set({ 'n', 'v' }, '<leader>cc', function()
            conform.format({ async = true, lsp_format = 'fallback' })
        end)

        require('mason-conform').setup()
    end
}