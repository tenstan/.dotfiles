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

                markdown = { 'prettierd' },
            },
            format_on_save = {
                timeout_ms = 500,
                -- lsp_format = 'fallback',    Due to mild annoyances, I only want to format on save when I have a formatter specifically configured
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
