-- low priority TODO: set up a Gherkin LSP. Unfortunately, cucumber-language-server doesn't cut it,
-- because it shows warnings that step definitions don't exist while starting (takes about 5 seconds), and it doesn't include
-- a formatter for formatting tables.

local on_lsp_attach = function(client, bufnr)
    local opts = { buffer = bufnr }

    -- Inlay hints are only wanted for the .NET language server for now.
    if client and client.name == 'easy_dotnet' and client:supports_method('textDocument/inlayHint', bufnr) then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    vim.keymap.set({ 'n', 'v' }, 'K', function()
        -- While the debugger is stopped, K inspects the value under the cursor instead of showing LSP docs.
        local dap = package.loaded['dap']
        local session = dap and dap.session()
        if session and session.stopped_thread_id then
            require('dap.ui.widgets').hover()
        else
            vim.lsp.buf.hover()
        end
    end, opts)
    vim.keymap.set('n', '<C-h>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)

    -- fzf-lua mappings:
    -- gd - go to definition
    -- gt - go to type definition
    -- gi - go to implementation
    -- gr - go to references
end

---@type LazySpec
return {
    {
        'mason-org/mason.nvim',
        cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonUpdate', 'MasonLog' },
        opts = {},
    },
    {
        'j-hui/fidget.nvim',
        event = 'VeryLazy',
        config = true,
    },
    {
        -- I'm only using this so types get recognized in the neovim config while maintaining quick lua_ls startup time.
        'folke/lazydev.nvim',
        ft = 'lua',
        ---@module 'lazydev'
        ---@type lazydev.Config
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                "lazy.nvim"
            },
        },
    },
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'mason-org/mason.nvim',
            'mason-org/mason-lspconfig.nvim',
            'saghen/blink.cmp'
        },
        -- NPM is required to install several LSPs
        --
        -- It's important that LSP plugins are set up in order:
        -- mason.nvim -> mason-lspconfig.nvim -> lspconfig
        config = function()
            local capabilities = require('blink.cmp').get_lsp_capabilities()

            local ensure_installed = {
                'bashls',        --
                'bicep',         --
                'clangd',        --
                'cssls',         --
                'cssmodules_ls', --
                'dockerls',      --
                'eslint',        --
                'html',          --
                'jsonls',        --
                'lua_ls',        --
                'marksman',      --
                'svelte',        --
                'vtsls',         --
                'yamlls'         --
            }

            if vim.fn.has('win32') == 1 then
                table.insert(ensure_installed, 'powershell_es')
            end

            vim.lsp.config('*', { capabilities = capabilities })
            vim.lsp.config('vtsls', {
                settings = {
                    vtsls = {
                        autoUseWorkspaceTsdk = true,
                    },
                },
            })
            -- Editor Services are in PowerShell 7; scripts can still target Windows PowerShell 5.1.
            vim.lsp.config('powershell_es', { shell = 'pwsh' })

            vim.lsp.config('cssmodules_ls', {
                init_options = { camelCase = true },
                on_attach = function(client)
                    client.server_capabilities.definitionProvider = false
                end,
            })

            require('mason-lspconfig').setup({
                ensure_installed = ensure_installed,
                -- easy-dotnet manages Roslyn; avoid a second C# client.
                automatic_enable = { exclude = { 'roslyn', 'roslyn_ls', 'omnisharp', 'csharp_ls' } },
            })

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)

                    on_lsp_attach(client, bufnr)
                end,
            })
        end
    },
}
