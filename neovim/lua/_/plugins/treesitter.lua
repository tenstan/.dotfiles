---@type LazySpec
return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
        { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    },
    config = function()
        local treesitter = require('nvim-treesitter')
        treesitter.setup()
        treesitter.install({
            'bash', 'bicep', 'c_sharp', 'cpp', 'css', 'dockerfile', 'html', 'http',
            'javascript', 'jsdoc', 'json', 'lua', 'markdown', 'markdown_inline',
            'sql', 'svelte', 'tsx', 'typescript', 'xml', 'yaml',
        })

        -- Enable Treesitter features when a buffer's filetype is set.
        vim.api.nvim_create_autocmd('FileType', {
            group = vim.api.nvim_create_augroup('UserTreesitter', { clear = true }),
            callback = function(args)
                -- Resolve the parser language for this filetype.
                local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
                if not lang then
                    return
                end

                -- Enable highlighting and indentation once the parser is available.
                local function attach()
                    if not vim.api.nvim_buf_is_valid(args.buf) then
                        return
                    end
                    if vim.treesitter.get_parser(args.buf, lang) then
                        vim.treesitter.start(args.buf, lang)
                        -- Keep the filetype's built-in indent rules when no Treesitter rules exist (e.g. C#).
                        if vim.treesitter.query.get(lang, 'indents') then
                            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                        end
                        -- Markdown still benefits from Vim's supplementary syntax rules.
                        if vim.bo[args.buf].filetype == 'markdown' then
                            vim.bo[args.buf].syntax = 'markdown'
                        end
                    end
                end

                -- Install missing languages and their queries before enabling features.
                local managed = vim.list_contains(treesitter.get_installed(), lang)
                if require('nvim-treesitter.parsers')[lang] and not managed then
                    treesitter.install({ lang }):await(function()
                        vim.schedule(attach)
                    end)
                elseif vim.treesitter.language.add(lang) then
                    -- Use an already available parser.
                    attach()
                end
            end,
        })

        require('nvim-treesitter-textobjects').setup({
            select = { lookahead = true },
            move = { set_jumps = true },
        })

        local selections = {
            ['im'] = '@function.inner',
            ['am'] = '@function.outer',
            ['ic'] = '@class.inner',
            ['ac'] = '@class.outer',
            ['a='] = '@assignment.outer',
            ['l='] = '@assignment.lhs',
            ['r='] = '@assignment.rhs',
        }
        for key, capture in pairs(selections) do
            vim.keymap.set({ 'x', 'o' }, key, function()
                require('nvim-treesitter-textobjects.select').select_textobject(capture, 'textobjects')
            end)
        end

        local movements = {
            [']m'] = { 'goto_next_start', '@function.outer' },
            [']c'] = { 'goto_next_start', '@class.outer' },
            ['[m'] = { 'goto_previous_start', '@function.outer' },
            ['[c'] = { 'goto_previous_start', '@class.outer' },
        }
        for key, movement in pairs(movements) do
            vim.keymap.set({ 'n', 'x', 'o' }, key, function()
                -- In diff mode, ]c and [c keep their built-in meaning: jumping between hunks.
                if vim.wo.diff and (key == ']c' or key == '[c') then
                    vim.cmd.normal({ vim.v.count1 .. key, bang = true })
                    return
                end

                require('nvim-treesitter-textobjects.move')[movement[1]](movement[2], 'textobjects')
            end)
        end

        local repeat_move = require('nvim-treesitter-textobjects.repeatable_move')
        vim.keymap.set({ 'n', 'x', 'o' }, ';', repeat_move.repeat_last_move_next)
        vim.keymap.set({ 'n', 'x', 'o' }, ',', repeat_move.repeat_last_move_previous)
        vim.keymap.set({ 'n', 'x', 'o' }, 'f', repeat_move.builtin_f_expr, { expr = true })
        vim.keymap.set({ 'n', 'x', 'o' }, 'F', repeat_move.builtin_F_expr, { expr = true })
        vim.keymap.set({ 'n', 'x', 'o' }, 't', repeat_move.builtin_t_expr, { expr = true })
        vim.keymap.set({ 'n', 'x', 'o' }, 'T', repeat_move.builtin_T_expr, { expr = true })
    end,
}
