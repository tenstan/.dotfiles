set -x EDITOR 'nvim'
set -x PAGER 'less'

set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_DATA_HOME "$HOME/.local/share"
set -x XDG_CACHE_HOME "$HOME/.cache"
set -x XDG_STATE_HOME "$HOME/.local/state"

set fish_prompt_pwd_dir_length 0  # Do not replace each directory of prompt pwd with a single letter
set fish_greeting                 # Disable welcome message

# Fish git prompt
set __fish_git_prompt_show_informative_status true
set __fish_git_prompt_showuntrackedfiles true # Warning, might severely impact performance
set __fish_git_prompt_showstashstate true
set __fish_git_prompt_showcolorhints true

set __fish_git_prompt_char_stateseparator " |"
set __fish_git_prompt_char_dirtystate " ~"
set __fish_git_prompt_char_untrackedfiles " ?"
set __fish_git_prompt_char_stagedstate " ✓"
set __fish_git_prompt_char_stashstate " 💾"
set __fish_git_prompt_char_cleanstate " ✔"
set __fish_git_prompt_char_upstream_ahead " ↑"
set __fish_git_prompt_char_upstream_behind " ↓"

set __fish_git_prompt_color_dirtystate yellow
set __fish_git_prompt_color_untrackedfiles red
set __fish_git_prompt_color_branch cyan

# ssh-agent

# ssh-agent.service should be enabled from install script. Keys are managed with KeepassXC.
# This needs to be set in order for KeepassXC SSH integration to function.
set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

