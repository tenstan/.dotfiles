-- TODO: Make it possible to re-run failed tests only
---@type LazySpec
return {
    'nvim-neotest/neotest',
    dependencies = {
        'nvim-neotest/nvim-nio',
        'nvim-lua/plenary.nvim',
        'antoinemadec/FixCursorHold.nvim',
        'nvim-treesitter/nvim-treesitter',
        'nvim-neotest/neotest-jest',
        'GustavEikaas/easy-dotnet.nvim',
    },
    config = function()
        local neotest = require('neotest')
        local nio = require('nio')

        ---@diagnostic disable-next-line: missing-fields
        neotest.setup({
            adapters = {
                require('neotest-jest')({
                    jestCommand = 'npm test',
                }),
                require('easy-dotnet.neotest'),
            },
            consumers = {
                -- Neotest has no built-in way to rerun only failures. A consumer is the only place that has access to the client's results.
                rerun = function(client)
                    return {
                        failed = nio.create(function()
                            local failed = {}
                            for _, adapter_id in ipairs(client:get_adapters()) do
                                for position_id, result in pairs(client:get_results(adapter_id)) do
                                    if result.status == 'failed' then
                                        local position = client:get_position(position_id, { adapter = adapter_id })
                                        if position and position:data().type == 'test' then
                                            table.insert(failed, { position_id, adapter = adapter_id })
                                        end
                                    end
                                end
                            end

                            if #failed == 0 then
                                vim.notify('No failed tests to rerun.', vim.log.levels.INFO)
                                return
                            end

                            for _, args in ipairs(failed) do
                                neotest.run.run(args)
                            end
                        end),
                    }
                end,
            },
        })

        -- easy-dotnet's adapter cannot run the root directory (the server has no node for it),
        -- so run every .NET project directory that contains tests instead.
        -- Other adapters run their whole suite.
        local function run_all_tests()
            local adapter_ids = neotest.state.adapter_ids()
            if #adapter_ids == 0 then
                vim.notify('No tests discovered yet. Open the test summary and wait for discovery.', vim.log.levels.WARN)
                return
            end

            for _, adapter_id in ipairs(adapter_ids) do
                if vim.startswith(adapter_id, 'easy-dotnet:') then
                    local tree = neotest.state.positions(adapter_id)
                    if tree then
                        for _, node in tree:iter_nodes() do
                            local position = node:data()
                            if position.type == 'dir' and #vim.fn.glob(position.path .. '/*.[cf]sproj', false, true) > 0 then
                                neotest.run.run(position.path)
                            end
                        end
                    end
                else
                    neotest.run.run({ suite = true, adapter = adapter_id })
                end
            end
        end

        vim.keymap.set('n', '<leader>tn', function() neotest.run.run() end,                                         { desc = 'Run nearest test' })
        vim.keymap.set('n', '<leader>td', function() neotest.run.run({ strategy = 'dap', suite = false }) end,      { desc = 'Debug nearest test' })
        vim.keymap.set('n', '<leader>ts', function() neotest.run.stop() end,                                        { desc = 'Stop currently running tests' })
        vim.keymap.set('n', '<leader>tt', function() neotest.summary.toggle() end,                                  { desc = 'Toggle test window' })
        vim.keymap.set('n', '<leader>ta', run_all_tests,                                                            { desc = 'Run all tests' })
        ---@diagnostic disable-next-line: undefined-field
        vim.keymap.set('n', '<leader>tf', function() neotest.rerun.failed() end,                                    { desc = 'Rerun failed tests' })
        vim.keymap.set('n', '<leader>tl', function() neotest.run.run_last() end,                                    { desc = 'Run last test selection' })
        vim.keymap.set('n', '<leader>to', function() neotest.output.open({ short = true, enter = true }) end, { desc = 'Open test output' })
    end
}
