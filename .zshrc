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

# Load all container functions from our repo file
[ -f "$HOME/dev-env-config/.zshrc-functions" ] && source "$HOME/dev-env-config/.zshrc-functions"

# --- Custom function to run the goose-host container ---
goose-host() {
  podman run -it --rm \
    -v ~/.config/goose:/root/.config/goose:U \
    -v ~/.gemini:/root/.gemini:U \
    -v ~/app-projects:/workspace/app-projects:U \
    -v ~/dev-env-config:/workspace/dev-env-config:U \
    -v ~/infra-projects:/workspace/infra-projects:U \
    -v ~/labs:/workspace/labs:U \
    -v ~/local-agent:/workspace/local-agent:U \
    -v ~/my-env:/workspace/my-env:U \
    -v ~/.cargo:/root/.cargo:U \
    -v ~/.dotnet:/root/.dotnet:U \
    -v ~/.rustup:/root/.rustup:U \
    -v ~/.terraform.d:/root/.terraform.d:U \
    -v ~/.vscode:/root/.vscode:U \
    -v ~/.gitconfig:/root/.gitconfig:ro,U \
    -v ~/.profile:/root/.profile:ro,U \
    -v ~/.zshenv:/root/.zshenv:ro,U \
    -v ~/.oh-my-zsh:/root/.oh-my-zsh:ro,U \
    goose-host
}
