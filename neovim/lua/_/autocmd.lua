local my_group = vim.api.nvim_create_augroup('MyGroup', {})
local yank_group = vim.api.nvim_create_augroup('HighlightYank', {})

-- Remove trailing whitespace on write, except where it is meaningful (markdown line breaks) or part of the content (diffs, Oil buffers)
local keep_trailing_whitespace = { markdown = true, diff = true, oil = true }

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = my_group,
    pattern = '*',
    callback = function(args)
        if keep_trailing_whitespace[vim.bo[args.buf].filetype] or not vim.bo[args.buf].modifiable then
            return
        end

        vim.api.nvim_buf_call(args.buf, function()
            local view = vim.fn.winsaveview()
            vim.cmd([[keeppatterns keepjumps %s/\s\+$//e]])
            vim.fn.winrestview(view)
        end)
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function ()
       vim.hl.on_yank({
            higroup = 'IncSearch',
            timeout = 200
        })
    end
})
