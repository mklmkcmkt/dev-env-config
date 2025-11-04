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