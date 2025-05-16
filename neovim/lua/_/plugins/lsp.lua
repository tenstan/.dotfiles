-- low priority TODO: set up a Gherkin LSP. Unfortunately, cucumber-language-server doesn't cut it,
-- because it shows warnings that step definitions don't exist while starting (takes about 5 seconds), and it doesn't include
-- a formatter for formatting tables.

local on_lsp_attach = function(client, bufnr)
    local opts = { buffer = bufnr }

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-h>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)

    -- Telescope mappings:
    -- gd - go to definition
    -- gt - go to type definition
    -- gi - go to implementaiton
    -- gr - go to references
end

return {
    {
        'j-hui/fidget.nvim',
        config = true,
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
        -- NPM is required to install several LSPs
        --
        -- It's important that LSP plugins are set up in order:
        -- mason.vnim -> mason-lspconfig.nvim -> lspconfig
        config = function()
            local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
            lsp_capabilities.textDocument.completion.completionItem.snippetSupport = true

            local cmp_lsp = require('cmp_nvim_lsp')
            local cmp_capabilities = cmp_lsp.default_capabilities()

            local capabilities = vim.tbl_deep_extend(
                'force',
                {},
                lsp_capabilities,
                cmp_capabilities)

            local ensure_installed = {
                'bashls',        --
                'cssls',         --
                'cssmodules_ls', --
                'dockerls',      --
                'eslint',        --
                'html',          --
                'jsonls',        --
                'lua_ls',        --
                'marksman',      --
                'svelte',        --
                'volar',         --
                'yamlls'         --
            }

            if vim.fn.has('win32') == 1 then
                table.insert(ensure_installed, 'powershell_es')
            end

            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = ensure_installed,
                handlers = {
                    function(server_name)
                        require('lspconfig')[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,

                    ['powershell_es'] = function()
                        require('lspconfig').powershell_es.setup({
                            shell = 'powershell.exe',
                        })
                    end,

                    ['cssmodules_ls'] = function()
                        require('lspconfig').cssmodules_ls.setup({
                            init_options = {
                                camelCase = true,
                            },
                            on_attach = function(client)
                                client.server_capabilities.definitionProvider = false
                            end
                        })
                    end,
                }
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
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("typescript-tools").setup({
                settings = {
                    tsserver_plugins = { "typescript-plugin-css-modules" },
                    filetypes = {
                        'javascript',
                        'javascriptreact',
                        'javascript.jsx',
                        'svelte',
                        'typescript',
                        'typescriptreact',
                        'typescript.tsx',
                    },
                },
            })
        end
    }
}
