---@type LazySpec
return {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npx --yes yarn install',
    init = function()
        vim.g.mkdp_filetypes = { 'markdown' }
        vim.g.mkdp_auto_close = 0               -- Don't close MarkdownPreview when switching buffers
        vim.g.mkdp_combine_preview = 1          -- Reuse previously opened preview when switching buffers
    end,
    ft = { 'markdown' }
}
