-- TODO: Make it possible to re-run failed tests only
---@type LazySpec
return {
    'nvim-neotest/neotest',
    dependencies = {
        'nvim-neotest/nvim-nio',
        'nvim-lua/plenary.nvim',
        'antoinemadec/FixCursorHold.nvim',
        'nvim-treesitter/nvim-treesitter',
        'nvim-neotest/neotest-jest'
    },
    config = function()
        local neotest = require('neotest')

        ---@diagnostic disable-next-line: missing-fields
        neotest.setup({
            adapters = {
                require('neotest-jest')({
                    jestCommand = 'npm test',
                }),
            },
        })

        vim.keymap.set('n', '<leader>tn', function() neotest.run.run() end,                   { desc = 'Run nearest test' })
        vim.keymap.set('n', '<leader>td', function() neotest.run.run(vim.fn.expand('%')) end, { desc = 'Run tests in document' })
        vim.keymap.set('n', '<leader>ts', function() neotest.run.stop() end,                  { desc = 'Stop currently running tests' })
        vim.keymap.set('n', '<leader>tt', function() neotest.summary.toggle() end,            { desc = 'Toggle test window' })
        vim.keymap.set('n', '<leader>ta', function() neotest.run.run({ suite = true }) end,   { desc = 'Run all tests' })
    end
}

