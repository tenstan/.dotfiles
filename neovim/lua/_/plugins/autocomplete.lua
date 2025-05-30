---@type LazySpec
return {
    {
        'windwp/nvim-ts-autotag',
        ---@module 'nvim-ts-autotag'
        ---@type nvim-ts-autotag.PluginSetup
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            opts = {
                enable_close = true,
                enable_rename = false, -- Handle through surround.nvim instead
            },

        },
        config = true,
    },
    {
        'windwp/nvim-autopairs',
        event = { 'InsertEnter' },
        config = true,
        opts = {
            disable_filetype = { 'ps1' }
        }
    },
    {
        'L3MON4D3/LuaSnip',
        dependencies = {
            'rafamadriz/friendly-snippets'
        },
        build = 'make install_jsregexp',
        config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
        end
    },
    {
        'saghen/blink.cmp',
        dependencies = {
            'rafamadriz/friendly-snippets',
            'L3MON4D3/LuaSnip'
        },
        version = '1.*', -- Using tagged releases ensures that a Rust binary is available, otherwise a Lua fallback will be provided
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = { preset = 'default' },
            snippets = { preset = 'luasnip' },
            appearance = {
                use_nvim_cmp_as_default = true,
            },
            cmdline = {
                keymap = {
                    preset = 'inherit'
                },
                completion = {
                    menu = {
                        auto_show = true
                    }
                }
            }
        },
    },
}
