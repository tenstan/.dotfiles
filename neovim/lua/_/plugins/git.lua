---@type LazySpec
return {
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            local gitsigns = require('gitsigns')

            gitsigns.setup({
                current_line_blame = true,
                current_line_blame_opts = {
                    delay = 200,
                }
            })

            vim.keymap.set('n', '<leader>gs', gitsigns.stage_hunk)
            vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk)
            vim.keymap.set('v', '<leader>gs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
            vim.keymap.set('v', '<leader>gr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
            vim.keymap.set('n', '<leader>gS', gitsigns.stage_buffer)
            vim.keymap.set('n', '<leader>gR', gitsigns.reset_buffer)
        end
    },
    {
        'sindrets/diffview.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            local actions = require('diffview.actions')

            require('diffview').setup({
                enhanced_diff_hl = true,
                view = {
                    default = {
                        layout = 'diff2_horizontal'
                    },
                    merge_tool = {
                        layout = 'diff4_mixed'
                    },
                    file_history = {
                        layout = 'diff2_horizontal'
                    }
                },
                keymaps = {
                    view = {
                        { "n", "[x",          actions.prev_conflict,                  { desc = "In the merge-tool: jump to the previous conflict" } },
                        { "n", "]x",          actions.next_conflict,                  { desc = "In the merge-tool: jump to the next conflict" } },
                        { "n", "<leader>gco",  actions.conflict_choose("ours"),        { desc = "Choose the OURS version of a conflict" } },
                        { "n", "<leader>gct",  actions.conflict_choose("theirs"),      { desc = "Choose the THEIRS version of a conflict" } },
                        { "n", "<leader>gcb",  actions.conflict_choose("base"),        { desc = "Choose the BASE version of a conflict" } },
                        { "n", "<leader>gca",  actions.conflict_choose("all"),         { desc = "Choose all the versions of a conflict" } },
                        { "n", "dx",          actions.conflict_choose("none"),        { desc = "Delete the conflict region" } }
                    },
                }
            })
        end
    }
}
