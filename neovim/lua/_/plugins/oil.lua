---@type LazySpec
return {
    'stevearc/oil.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons'
    },
    -- Lazy loading is not recommended for oil.nvim because it is very tricky to make it work correctly in all situations
    lazy = false,
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        view_options = {
            is_hidden_file = function(name, _)
                local patterns = {
                    "^%.git$" -- Matches only ".git"
                }

                for _, pattern in ipairs(patterns) do
                    if name:match(pattern) then
                        return true
                    end
                end

                return false
            end,
        },
        lsp_file_methods = {
            autosave_changes = true
        },
    },
    keys = {
        { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
}
