# --- Container Configuration ---

# 1. Global Helpers
def get-home [] { $env.HOME }

def get-common-mounts [] {
    let home = (get-home)
    [
        # Git config is essential for your 'Git-first' rule
        "-v" $"($home)/dev-env-config/.gitconfig:/root/.gitconfig"
        
        # --- Nushell Sync ---
        # This ensures the container shell behaves exactly like your host shell
        "-v" $"($home)/dev-env-config/config.nu:/root/.config/nushell/config.nu"
        "-v" $"($home)/dev-env-config/containers.nu:/root/.config/nushell/containers.nu"

        # Secrets and Cloud Configs (Renamed from Zsh to Dev for clarity)
        "-v" $"($home)/.dev_secrets:/root/.dev_secrets:ro"
        "-v" $"($home)/dev-env-config:/etc/dev-env-config"
        "-v" $"($home)/.config/gcloud:/root/.config/gcloud"
        "-v" $"($home)/snap/gh/current/.config/gh:/root/.config/gh"
        "-v" $"($home)/.ssh:/root/.ssh:ro"
    ]
}

# 2. Main Helper Command
def run-dev [name: string, project_src: string, image: string, extra_args: list<string> = [], container_cmd: list<string> = []] {
    let base_args = [
        "run" "-it" "--rm" "--replace" 
        "--name" $name 
        "-v" $"($project_src):/projects"
        # Intel GPU & NPU Passthrough for your Lunar Lake VPU
        "--device" "/dev/dri" 
        # Pass the Podman socket for "Docker-in-Podman" workflows
        "-e" $"DOCKER_HOST=unix:///run/user/(id -u)/podman/podman.sock"
    ]
    
    let final_args = ($base_args 
        | append (get-common-mounts) 
        | append $extra_args 
        | append $image 
        | append $container_cmd)
        
    ^podman ...$final_args
}

# 3. Exported Dev Commands
export def apps [...args: string] { 
    let home = (get-home)
    let cmd = if ($args | is-empty) { ["nu"] } else { $args }
    run-dev "dev-apps" $"($home)/dev-env/app" "localhost/dev-apps:latest" ["-v" $"($home)/.kube:/root/.kube"] $cmd
}

export def infra [...args: string] { 
    let home = (get-home)
    let cmd = if ($args | is-empty) { ["nu"] } else { $args }
    run-dev "dev-infra" $"($home)/dev-env/infra" "localhost/dev-infra:latest" ["-v" $"($home)/.kube:/root/.kube"] $cmd
}

export def base [...args: string] { 
    let home = (get-home)
    let cmd = if ($args | is-empty) { ["nu"] } else { $args }
    run-dev "base-dev" $home "localhost/dev-base:latest" ["-v" $"($home)/.kube:/root/.kube"] $cmd
}

