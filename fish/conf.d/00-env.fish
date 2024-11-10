set -x EDITOR 'nvim'
set -x PAGER 'less'

set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_DATA_HOME "$HOME/.local/share"
set -x XDG_CACHE_HOME "$HOME/.cache"
set -x XDG_STATE_HOME "$HOME/.local/state"

# ssh-agent.service should be enabled from install script. Keys are managed with KeepassXC.
set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

set fish_prompt_pwd_dir_length 0  # Do not replace each directory of prompt pwd with a single letter
set fish_greeting                 # Disable welcome message
