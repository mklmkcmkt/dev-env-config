# Set the path to the Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set the theme
ZSH_THEME="robbyrussell"

# -----------------------------------------------------------------------------
# PLUGINS CONFIGURATION
# Defined BEFORE sourcing Oh My Zsh.
# Based on my tools: Podman, Rust, Terraform, Git, GitHub CLI, and Ubuntu.
# -----------------------------------------------------------------------------
plugins=(
  git           # Standard git aliases and functions [cite: 211]
  podman        # Autocompletion and aliases for Podman 
  rust          # Completion for rustc, cargo, and rustup 
  terraform     # Completion and aliases for Terraform 
  gh            # Completion for GitHub CLI [cite: 210]
  ubuntu        # Ubuntu/Debian package manager aliases [cite: 519]
  gcloud        # Completion for Google Cloud SDK   
  vscode        # Aliases for VS Code interaction [cite: 532]
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# --- Custom Additions ---

# 1. Set System Paths FIRST so specific tools can override them later
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Load personal secrets (like API keys) if the file exists
[ -f "$HOME/.zsh_secrets" ] && source "$HOME/.zsh_secrets"

# Load cargo path (for nu, jj, goose, etc.)
# This prepends ~/.cargo/bin AHEAD of /usr/bin, allowing Rust replacements to take precedence
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Load all container functions from our repo file
[ -f "$HOME/dev-env-config/.zshrc-functions" ] && source "$HOME/dev-env-config/.zshrc-functions"

# --- Host-Specific Additions ---
# Only add the host's VS Code path if we are actually on the host.
if [ -f "/usr/share/code/code" ]; then
  export PATH="$PATH:/usr/share/code"
fi

# Run Gemini CLI in a sandboxed Podman container
gemini() {
    podman run -it --rm \
    -v "$HOME/.gemini:/root/.gemini" \
    -v "$PWD":/workspace \
    gemini-cli "$@"
}

# --- Firefox ---
# Force Firefox to use Wayland to fix blurry text on Samsung M7 4K Monitor
export MOZ_ENABLE_WAYLAND=1