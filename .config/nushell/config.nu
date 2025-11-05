# --- Container Aliases ---

# Get the absolute string value of the home path once
let home_path = $env.HOME

# Custom command to start the APP container
def apps [] {
    let args = [
        "run", "-it", "--rm",
        "-v", ( $home_path + '/dev-env-config/.zshrc-container:/root/.zshrc' ),
        "-v", ( $home_path + '/dev-env-config/.gitconfig:/root/.gitconfig' ),
        "-v", ( $home_path + '/dev-env-config/config.nu:/root/.config/nushell/config.nu' ),
        "-v", ( $home_path + '/.zsh_secrets:/root/.zsh_secrets:ro' ),
        "-v", ( $home_path + '/app-projects:/projects' ),
        "-v", ( $home_path + '/.config/gcloud:/root/.config/gcloud' ),
        "-v", ( $home_path + '/snap/gh/current/.config/gh:/root/.config/gh' ),
        "-v", ( $home_path + '/.ssh:/root/.ssh:ro' ),
        "-e", "GEMINI_API_KEY",
        "--name", "app-dev",
        "localhost/dev-app:latest"
    ]
    ^podman ...$args
}

# Custom command to start the INFRA container
def infra [] {
    let args = [
        "run", "-it", "--rm",
        "-v", ( $home_path + '/dev-env-config/.zshrc-container:/root/.zshrc' ),
        "-v", ( $home_path + '/dev-env-config/.gitconfig:/root/.gitconfig' ),
        "-v", ( $home_path + '/dev-env-config/config.nu:/root/.config/nushell/config.nu' ),
        "-v", ( $home_path + '/.zsh_secrets:/root/.zsh_secrets:ro' ),
        "-v", ( $home_path + '/infra-projects:/projects' ),
        "-v", ( $home_path + '/.config/gcloud:/root/.config/gcloud' ),
        "-v", ( $home_path + '/.kube:/root/.kube' ),
        "-v", ( $home_path + '/snap/gh/current/.config/gh:/root/.config/gh' ),
        "-v", ( $home_path + '/.ssh:/root/.ssh:ro' ),
        "-e", "GEMINI_API_KEY",
        "--name", "infra-dev",
        "localhost/dev-infra:latest"
    ]
    ^podman ...$args
}

# Custom command to start the BASE container
def base [] {
    let args = [
        "run", "-it", "--rm",
        "-v", ( $home_path + '/dev-env-config/.zshrc-container:/root/.zshrc' ),
        "-v", ( $home_path + '/dev-env-config/.gitconfig:/root/.gitconfig' ),
        "-v", ( $home_path + '/dev-env-config/config.nu:/root/.config/nushell/config.nu' ),
        "-v", ( $home_path + '/.zsh_secrets:/root/.zsh_secrets:ro' ),
        "-v", ( $home_path + ':/projects' ),
        "-v", ( $home_path + '/.config/gcloud:/root/.config/gcloud' ),
        "-v", ( $home_path + '/.kube:/root/.kube' ),
        "-v", ( $home_path + '/snap/gh/current/.config/gh:/root/.config/gh' ),
        "-v", ( $home_path + '/.ssh:/root/.ssh:ro' ),
        "-e", "GEMINI_API_KEY",
        "--name", "base-dev",
        "localhost/dev-base:latest"
    ]
    ^podman ...$args
}

# --- Custom alias to run the goose-host container ---
alias goose-host = podman run -it --rm \
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