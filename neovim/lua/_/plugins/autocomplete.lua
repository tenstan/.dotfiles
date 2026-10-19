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
        'saghen/blink.cmp',
        event = { 'InsertEnter', 'CmdlineEnter' },
        dependencies = {
            -- blink loads these snippets with its built-in snippet engine
            'rafamadriz/friendly-snippets',
        },
        version = '1.*', -- Using tagged releases ensures that a Rust binary is available, otherwise a Lua fallback will be provided
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = { preset = 'default' },
            signature = { enabled = true },
            sources = {
                per_filetype = {
                    lua = { inherit_defaults = true, 'lazydev' },
                },
                providers = {
                    lazydev = {
                        name = 'LazyDev',
                        module = 'lazydev.integrations.blink',
                        score_offset = 100, -- Show lazydev completions above the rest
                    },
                },
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
