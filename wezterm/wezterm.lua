local wezterm = require('wezterm')
local act = wezterm.action

-- Apply to tab-bar close buttons and default actions as well as our shortcuts.
wezterm.on('mux-is-process-stateful', function()
    return false
end)

local pane_shells = {}

wezterm.on('format-tab-title', function(tab)
    local pane = tab.active_pane
    local process = (pane.foreground_process_name or ''):match('([^/\\]+)$') or ''
    process = process:lower():gsub('%.exe$', '')

    local shells = {
        pwsh = { wezterm.nerdfonts.md_powershell, '#78A9FF' },
        powershell = { wezterm.nerdfonts.md_powershell, '#3975A8' },
        wsl = { wezterm.nerdfonts.linux_archlinux, '#F8E6A0' },
        wslhost = { wezterm.nerdfonts.linux_archlinux, '#F8E6A0' },
        bash = { wezterm.nerdfonts.cod_terminal_bash, '#7AC098' },
        zsh = { wezterm.nerdfonts.dev_terminal, '#A3A0D8' },
        fish = { wezterm.nerdfonts.dev_terminal, '#9AC6E0' },
        cmd = { wezterm.nerdfonts.cod_terminal_cmd, '#E0E0E0' },
    }
    local shell = pane_shells[pane.pane_id]
    if not shell then
        shell = (pane.domain_name or ''):match('^WSL:') and shells.wsl or shells[process]
        if shell then
            pane_shells[pane.pane_id] = shell
        elseif wezterm.target_triple:find('windows') then
            -- Startup helpers may be reported before the shell itself.
            local success = wezterm.run_child_process({ 'where.exe', 'pwsh.exe' })
            shell = success and shells.pwsh or shells.powershell
        end
    end

    local icon = shell and shell[1] or wezterm.nerdfonts.dev_terminal
    local color = shell and shell[2] or '#B5BDC5'
    return {
        { Foreground = { Color = color } },
        { Text = '  ' .. icon .. '  ' },
    }
end)

-- Derived from midnight.nvim
-- https://github.com/dasupradyumna/midnight.nvim/blob/main/extras/kitty/midnight.conf
local colors = {
    foreground = '#B5BDC5',
    background = '#080C10',

    cursor_bg = '#FFFFFF',
    cursor_fg = '#080C10',
    cursor_border = '#FFFFFF',

    selection_fg = '#b5bdc5',
    selection_bg = '#012749',

    split = '#985EFF',

    tab_bar = {
        -- Blend inactive tab separators into their default background.
        inactive_tab_edge = '#333333',
        inactive_tab_edge_hover = '#1F1F1F',
    },

    ansi = {
        '#181818', -- Black
        '#fa4d56', -- Red
        '#42be65', -- Green
        '#c8b670', -- Yellow
        '#5080ff', -- Blue
        '#a665d0', -- Magenta
        '#50b0e0', -- Cyan
        '#b5bdc5', -- White
    },
    brights = {
        '#525252', -- Bright Black
        '#ff7279', -- Bright Red
        '#7ac098', -- Bright Green
        '#f8e6a0', -- Bright Yellow
        '#78a9ff', -- Bright Blue
        '#a3a0d8', -- Bright Magenta
        '#9ac6e0', -- Bright Cyan
        '#e0e0e0', -- Bright White
    },
}

local keys = {
    -- Preserve Shift+Enter as a distinct key for multiline prompts.
    { key = 'Enter', mods = 'SHIFT', action = act.SendString('\x1b[13;2u') },
    { key = 'p', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette },
    { key = 'Space', mods = 'CTRL|SHIFT', action = act.QuickSelect },
    { key = 'x', mods = 'CTRL|SHIFT', action = act.ActivateCopyMode },
    { key = 'r', mods = 'CTRL|SHIFT', action = act.ReloadConfiguration },
    { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom('Clipboard') },
    { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo('Clipboard') },
    { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentTab({ confirm = false }) },
}

for number = 1, 9 do
    table.insert(keys, {
        key = 'phys:' .. number,
        mods = 'CTRL|ALT',
        action = wezterm.action_callback(function(window, pane)
            local count = #window:mux_window():tabs()
            window:perform_action(act.ActivateTab(math.min(number, count) - 1), pane)
        end),
    })
end

local yank = act.Multiple({ act.CopyTo('Clipboard'), act.CopyMode('ClearSelectionMode') })
local copy_mode = {
    { key = 'Escape', mods = 'NONE', action = act.CopyMode('ClearSelectionMode') },
    { key = 'q', mods = 'NONE', action = act.CopyMode('Close') },
    { key = 'y', mods = 'NONE', action = yank },
    { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo('Clipboard') },
    { key = 'v', mods = 'NONE', action = act.CopyMode({ SetSelectionMode = 'Cell' }) },
    { key = 'V', mods = 'NONE', action = act.CopyMode({ SetSelectionMode = 'Line' }) },
    { key = 'v', mods = 'CTRL', action = act.CopyMode({ SetSelectionMode = 'Block' }) },
    { key = '/', mods = 'NONE', action = act.Multiple({
        act.CopyMode('ClearPattern'), act.CopyMode('EditPattern'),
    }) },
    { key = 'n', mods = 'NONE', action = act.CopyMode('NextMatch') },
    { key = 'N', mods = 'NONE', action = act.CopyMode('PriorMatch') },
    { key = 'g', mods = 'NONE', action = act.ActivateKeyTable({
        name = 'copy_mode_g', one_shot = true, until_unknown = true, timeout_milliseconds = 1000,
    }) },
    { key = 'u', mods = 'CTRL', action = act.CopyMode({ MoveByPage = -0.5 }) },
    { key = 'd', mods = 'CTRL', action = act.CopyMode({ MoveByPage = 0.5 }) },
    { key = 'b', mods = 'CTRL', action = act.CopyMode('PageUp') },
    { key = 'f', mods = 'CTRL', action = act.CopyMode('PageDown') },
    { key = 'f', mods = 'NONE', action = act.CopyMode({ JumpForward = { prev_char = false } }) },
    { key = 'F', mods = 'NONE', action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
    { key = 't', mods = 'NONE', action = act.CopyMode({ JumpForward = { prev_char = true } }) },
    { key = 'T', mods = 'NONE', action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
}
for key, motion in pairs({
    h = 'MoveLeft', j = 'MoveDown', k = 'MoveUp', l = 'MoveRight',
    w = 'MoveForwardWord', b = 'MoveBackwardWord', e = 'MoveForwardWordEnd',
    G = 'MoveToScrollbackBottom', ['0'] = 'MoveToStartOfLine',
    ['^'] = 'MoveToStartOfLineContent', ['$'] = 'MoveToEndOfLineContent',
    [';'] = 'JumpAgain', Enter = 'MoveToStartOfNextLine',
}) do
    table.insert(copy_mode, { key = key, mods = 'NONE', action = act.CopyMode(motion) })
end

-- Preserve shifted characters across keyboard layouts and key event encodings.
for _, binding in ipairs({ table.unpack(copy_mode) }) do
    if binding.mods == 'NONE' and binding.key:match('^[A-Z%^%$]$') then
        table.insert(copy_mode, { key = binding.key, mods = 'SHIFT', action = binding.action })
    end
end

local config = {
    window_close_confirmation = 'NeverPrompt',
    colors = colors,
    font = wezterm.font('FiraCode Nerd Font', { weight = 'Medium' }),
    keys = keys,
    disable_default_key_bindings = true,
    key_tables = {
        copy_mode = copy_mode,
        copy_mode_g = {
            { key = 'g', mods = 'NONE', action = act.CopyMode('MoveToScrollbackTop') },
            { key = 'Escape', mods = 'NONE', action = act.Multiple({
                act.PopKeyTable, act.CopyMode('ClearSelectionMode'),
            }) },
        },
        search_mode = {
            { key = 'Enter', mods = 'NONE', action = act.CopyMode('AcceptPattern') },
            { key = 'Escape', mods = 'NONE', action = act.CopyMode('AcceptPattern') },
            { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom('Clipboard') },
        },
    },
    quick_select_patterns = {
        '[0-9a-zA-Z]+[._-][0-9a-zA-Z._-]+'
    },
    font_size = 11,
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
    command_palette_font_size = 11,
    command_palette_bg_color = '#525252'
}

if wezterm.target_triple:find('windows') then
    -- A heavier face gives text more solid strokes with FreeType rendering.
    config.font = wezterm.font('FiraCode Nerd Font', { weight = 'DemiBold' })

    -- Resolve PowerShell Core from PATH, including Microsoft Store app aliases.
    local success, stdout = wezterm.run_child_process({ 'where.exe', 'pwsh.exe' })
    local pwsh = success and stdout:match('[^\r\n]+') or nil
    local powershell = { pwsh or 'powershell.exe', '-NoLogo' }
    -- Omitting --distribution follows the user's current default WSL distro.
    local wsl = { 'wsl.exe', '--cd', '~' }

    config.default_prog = powershell
    config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
    config.window_frame = {
        font = wezterm.font('FiraCode Nerd Font', { weight = 'DemiBold' }),
        font_size = 12,
    }
    config.launch_menu = {
        { label = '1: PowerShell', args = powershell },
        { label = '2: WSL (default distribution)', args = wsl },
    }

    table.insert(keys, {
        key = 'phys:1',
        mods = 'CTRL|SHIFT',
        action = act.SpawnCommandInNewTab({ args = powershell, domain = 'DefaultDomain' }),
    })
    table.insert(keys, {
        key = 'phys:2',
        mods = 'CTRL|SHIFT',
        action = act.SpawnCommandInNewTab({ args = wsl, domain = 'DefaultDomain' }),
    })
else
    config.enable_tab_bar = false
    config.line_height = 1.2
    local success, stdout = wezterm.run_child_process({ 'sh', '-c', 'command -v fish' })
    local fish = success and stdout:match('[^\r\n]+') or nil
    config.default_prog = { fish or 'bash', '-l' }
    config.launch_menu = { { label = fish and '1: Fish' or '1: Bash', args = config.default_prog } }
    table.insert(keys, {
        key = 'phys:1',
        mods = 'CTRL|SHIFT',
        action = act.SpawnCommandInNewTab({ args = config.default_prog, domain = 'DefaultDomain' }),
    })
end

-- Optional device-specific overrides next to the active configuration file.
local local_path = wezterm.config_dir .. '/wezterm.local.lua'
wezterm.add_to_config_reload_watch_list(local_path)
local local_file = io.open(local_path, 'r')
if local_file then
    local_file:close()
    local configure = assert(loadfile(local_path))()
    if type(configure) == 'function' then
        configure(config)
    else
        error('wezterm.local.lua must return a function(config)')
    end
end

return config
