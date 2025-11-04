# Set the path to the Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set the theme
ZSH_THEME="robbyrussell"

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# --- Custom Additions ---

# Load personal secrets (like API keys) if the file exists
[ -f "$HOME/.zsh_secrets" ] && source "$HOME/.zsh_secrets"

# Load cargo path (for nu, jj, goose, etc.)
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Load all container functions
[ -f "$HOME/dev-env-config/.zshrc-functions" ] && source "$HOME/dev-env-config/.zshrc-functions"
