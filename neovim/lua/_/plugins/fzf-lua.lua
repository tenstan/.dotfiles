-- Names that are excluded from file lists and searches. They are handed to fd and ripgrep themselves, so these
-- directories are never walked, instead of being filtered out afterwards. A name matches any file or directory
-- with exactly that name, at any depth.
local ignored = {
    'node_modules',
    'dist',
    'package-lock.json',
    'yarn.lock',
    '.git',
    '.vs',
    '.idea',
    'bin',
    'obj',
}

local function fd_file_options(excluded)
    local options = '--color=never --type f --type l'

    for _, name in ipairs(excluded) do
        options = options .. ' --exclude ' .. name
    end

    return options
end

local function rg_file_options(excluded)
    local options = '--color=never --files'

    for _, name in ipairs(excluded) do
        options = options .. ' -g "!' .. name .. '"'
    end

    return options
end

local function rg_grep_options(excluded, extra_flags)
    local options = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden'
        .. (extra_flags or '')

    for _, name in ipairs(excluded) do
        options = options .. ' -g "!' .. name .. '"'
    end

    -- fzf-lua appends the search query after the last option, which has to be -e
    return options .. ' -e'
end

local function find_files(excluded)
    require('fzf-lua').files({
        hidden = true,
        no_ignore = true,
        fd_opts = fd_file_options(excluded),
        rg_opts = rg_file_options(excluded),
    })
end

local function live_grep(excluded, extra_flags)
    require('fzf-lua').live_grep({
        rg_opts = rg_grep_options(excluded, extra_flags),
    })
end

---@type LazySpec
return {
    'ibhagwan/fzf-lua',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    cmd = 'FzfLua',
    init = function()
        -- Load fzf-lua the first time something calls vim.ui.select, and let it take over from then on.
        vim.ui.select = function(...)
            require('lazy').load({ plugins = { 'fzf-lua' } })
            require('fzf-lua').register_ui_select()
            return vim.ui.select(...)
        end
    end,
    opts = {
        -- Keep wide Nerd Font icons' overhanging right edge inside the colored span.
        file_icon_padding = ' ',
        files = {
            formatter = 'path.filename_first',
            -- Keep the filename visible instead of scrolling left to show matches in the path.
            fzf_opts = { ['--no-hscroll'] = true },
        },
        grep = {
            formatter = 'path.filename_first',
            -- Keep the filename visible when matches occur later in the result.
            fzf_opts = { ['--no-hscroll'] = true },
        },
    },
    keys = {
        { 'gd', function() require('fzf-lua').lsp_definitions() end },
        { 'gt', function() require('fzf-lua').lsp_typedefs() end },
        { 'gi', function() require('fzf-lua').lsp_implementations() end },
        { 'gr', function() require('fzf-lua').lsp_references({ ignore_current_line = true }) end },
        { '<leader>fs', function() require('fzf-lua').lsp_live_workspace_symbols() end },

        { '<leader>xd', function() require('fzf-lua').diagnostics_workspace() end },
        { '<leader>xq', function() require('fzf-lua').quickfix() end },

        { '<leader>fr', function() require('fzf-lua').resume() end },

        -- Lowercase hides the ignored names above, uppercase searches everything except .git
        { '<leader>ff', function() find_files(ignored) end },
        { '<leader>fF', function() find_files({ '.git' }) end },
        { '<leader>fw', function() live_grep(ignored) end },
        { '<leader>fW', function() live_grep({ '.git' }, ' --no-ignore') end },
    },
}
