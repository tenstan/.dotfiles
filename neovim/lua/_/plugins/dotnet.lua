---@type LazySpec
return {
    'GustavEikaas/easy-dotnet.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'neovim/nvim-lspconfig',
    },
    ft = { 'cs', 'csproj', 'fs', 'fsproj', 'sln' },
    cmd = { 'Dotnet', 'DotnetAddProjectReference' },
    -- To support auto_bootstrap_namespace before the plugin is loaded
    event = { 'BufReadPre *.cs', 'BufNewFile *.cs' },
    opts = {
        picker = 'telescope',
        projx_lsp = {
            enabled = true
        },
        lsp = {
            enabled = true,
            daemon_mode = false,
            preload_roslyn = true,
            auto_refresh_codelens = false,
            config = {
                capabilities = {
                    workspace = {
                        -- Using out-of-process file watching has shown freezes on Windows when building with ':Dotnet build solution'.
                        didChangeWatchedFiles = { dynamicRegistration = false },
                    },
                },
                settings = {
                    ['csharp|background_analysis'] = {
                        dotnet_analyzer_diagnostics_scope = 'openFiles',
                        dotnet_compiler_diagnostics_scope = 'openFiles',
                    },
                    ['csharp|code_lens'] = {
                        dotnet_enable_references_code_lens = false,
                        dotnet_enable_tests_code_lens = false,
                    },
                    ['csharp|completion'] = {
                        dotnet_show_completion_items_from_unimported_namespaces = true,
                    },
                    ['csharp|inlay_hints'] = {
                        csharp_enable_inlay_hints_for_types = true,
                        csharp_enable_inlay_hints_for_implicit_variable_types = false,
                        csharp_enable_inlay_hints_for_implicit_object_creation = true,
                        csharp_enable_inlay_hints_for_lambda_parameter_types = true,

                        dotnet_enable_inlay_hints_for_parameters = true,
                        dotnet_enable_inlay_hints_for_literal_parameters = true,
                        dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                        dotnet_enable_inlay_hints_for_indexer_parameters = true,
                        dotnet_enable_inlay_hints_for_other_parameters = true,

                        dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                        dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
                        dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                    },
                    ['csharp|formatting'] = {
                        dotnet_organize_imports_on_format = true,
                    },
                },
            },
            razor = {
                enabled = true,
                html = {
                    enabled = true,
                }
            },
            easy_dotnet_extension_enabled = true,
            enhanced_rename = true,
            create_type_from_usage  = true,
            restart_roslyn_on_branch_change = true,
            bulk_filewatcher_registrations = true,
        },
        debugger = { auto_register_dap = false },
        test_runner = {
            auto_start_testrunner = false,
            neotest_integration = true
        },
        csproj_mappings = false,
        fsproj_mappings = false,
        auto_bootstrap_namespace = {
            enabled = true,
            type = 'file_scoped',
            use_clipboard_json = {
                behavior = 'never',
            }
        },
    },
    config = function(_, opts)
        require('easy-dotnet').setup(opts)

        vim.api.nvim_create_user_command('DotnetAddProjectReference', function()
            local project = vim.api.nvim_buf_get_name(0)
            if not project:lower():match('%.csproj$') then
                vim.notify('Open a .csproj to add a project reference.', vim.log.levels.WARN)
                return
            end

            require('easy-dotnet.csproj-mappings').add_project_reference(project)
        end, {
            desc = 'Add a project reference to the current C# project',
        })
    end,
    keys = {
        { '<leader>ba', '<cmd>Dotnet build solution quickfix<CR>', desc = 'Build .NET solution to quickfix' },
        { '<leader>bA', '<cmd>Dotnet build solution<CR>', desc = 'Build .NET solution' },
        { '<leader>bb', '<cmd>Dotnet build quickfix<CR>', desc = 'Build .NET project (picker) to quickfix' },
        { '<leader>bB', '<cmd>Dotnet build<CR>', desc = 'Build .NET project (picker)' },
        { '<leader>bc', '<cmd>Dotnet clean<CR>', desc = 'Clean .NET project/solution (picker)' },
        { '<leader>bs', function() vim.notify('easy-dotnet cannot stop a running build. Use Ctrl+C in the build terminal.', vim.log.levels.WARN) end, desc = 'Build stop unavailable', },
        { '<leader>br', '<cmd>Dotnet restore<CR>', desc = 'Restore .NET packages' },
        { '<leader>rr', '<cmd>Dotnet run<CR>', desc = 'Run .NET project (picker)' },
        { '<leader>rs', function() require('easy-dotnet').stop() end, desc = 'Stop the running .NET project' },
    },
}
