local wezterm = require('wezterm')
local act = wezterm.action

-- Derived from midnight.nvim
-- https://github.com/dasupradyumna/midnight.nvim/blob/main/extras/kitty/midnight.conf
local colors = {
    foreground = '#D7D7D7',
    background = '#000000',

    selection_fg = '#b5bdc5',
    selection_bg = '#012749',

    split = '#985EFF',

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
    {
        key = 'v',
        mods = 'ALT',
        action = wezterm.action.SplitHorizontal({})
    },
    {
        key = 's',
        mods = 'ALT',
        action = wezterm.action.SplitVertical({})
    },
    {
        key = 'q',
        mods = 'ALT',
        action = wezterm.action.CloseCurrentPane({ confirm = true })
    },
    {
        key = 'h',
        mods = 'ALT',
        action = act.ActivatePaneDirection('Left')
    },
    {
        key = 'j',
        mods = 'ALT',
        action = act.ActivatePaneDirection('Down')
    },
    {
        key = 'k',
        mods = 'ALT',
        action = act.ActivatePaneDirection('Up')
    },
    {
        key = 'l',
        mods = 'ALT',
        action = act.ActivatePaneDirection('Right')
    },
    {
        key = 'u',
        mods = 'ALT',
        action = act.AdjustPaneSize({ 'Left', 5 })
    },
    {
        key = 'i',
        mods = 'ALT',
        action = act.AdjustPaneSize({ 'Down', 5 })
    },
    {
        key = 'o',
        mods = 'ALT',
        action = act.AdjustPaneSize({ 'Up', 5 })
    },
    {
        key = 'p',
        mods = 'ALT',
        action = act.AdjustPaneSize({ 'Right', 5 })
    }
}

return {
    automatically_reload_config = true,
    enable_tab_bar = false,
    colors = colors,
    font = wezterm.font('FiraCode Nerd Font', { weight = 'Medium' }),
    force_reverse_video_cursor = true,
    keys = keys,
    line_height = 1.2,
    font_size = 11,
    enable_wayland = false, -- Wezterm doesn't start at all when using Hyprland without this
}
