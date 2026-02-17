# --- Container Configuration ---

# 1. Global Helpers
def get-home [] { $env.HOME }

def get-common-mounts [] {
    let home = (get-home)
    [
        # Mount Zsh configs (Legacy support)
        "-v" $"($home)/dev-env-config/.zshrc-container:/root/.zshrc"
        "-v" $"($home)/dev-env-config/.zshrc-functions:/root/.zshrc-functions"
        "-v" $"($home)/dev-env-config/.gitconfig:/root/.gitconfig"
        
        # --- CRITICAL FIX 1: Mount BOTH Nushell config files ---
        "-v" $"($home)/dev-env-config/config.nu:/root/.config/nushell/config.nu"
        "-v" $"($home)/dev-env-config/containers.nu:/root/.config/nushell/containers.nu"
        # -------------------------------------------------------

        # Secrets and Cloud Configs
        "-v" $"($home)/.zsh_secrets:/root/.zsh_secrets:ro"
        "-v" $"($home)/dev-env-config:/etc/dev-env-config"
        "-v" $"($home)/.config/gcloud:/root/.config/gcloud"
        "-v" $"($home)/snap/gh/current/.config/gh:/root/.config/gh"
        "-v" $"($home)/.ssh:/root/.ssh:ro"
    ]
}

# 2. Main Helper Command
def run-dev [name: string, project_src: string, image: string, extra_args: list<string> = [], container_cmd: list<string> = []] {
    let base_args = ["run" "-it" "--rm" "--replace" "--name" $name "-v" $"($project_src):/projects"]
    
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
    
    # CHANGE IS HERE: Added ["-w" "/projects"]
    run-dev "app-dev" $"($home)/app-projects" "localhost/apps:latest" ["-w" "/projects"] $cmd
}

export def infra [...args: string] { 
    let home = (get-home)
    let cmd = if ($args | is-empty) { ["nu"] } else { $args }

    # --- CRITICAL FIX 2: Use the NEW image name (infra vs dev-infra) ---
    run-dev "infra-dev" $"($home)/infra-projects" "localhost/infra:latest" ["-v" $"($home)/.kube:/root/.kube"] $cmd
}

export def base [...args: string] { 
    let home = (get-home)
    let cmd = if ($args | is-empty) { ["nu"] } else { $args }

    run-dev "base-dev" $home "localhost/dev-base:latest" ["-v" $"($home)/.kube:/root/.kube"] $cmd
}