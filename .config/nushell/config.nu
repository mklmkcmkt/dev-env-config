# --- Nushell Config ---
$env.config.show_banner = false

# --- Secrets Management ---
# Load your Gemini API keys and GCP tokens (Nushell format)
    source ~/.dev_secrets


# --- Container Management ---
# Dynamically locate and load containers.nu relative to this file
source ~/dev-env-config/containers.nu

# --- GCP & Antigravity Workflow ---
# Use this to reset the project context for Cloud Code and Gemini
def gcp-init [project_id: string] {
    # 1. Set the active project in gcloud CLI
    gcloud config set project $project_id

    # 2. Create the workspace settings directory
    mkdir .antigravity

    # 3. Generate local settings.json for Cloud Code/Gemini
    let settings = {
        "cloudcode.project": $project_id,
        "geminicodeassist.project": $project_id
    }

    $settings | save -f .antigravity/settings.json
    
    print $"🚀 Workspace initialized for project: ($project_id)"
    print "Antigravity will now prioritize this GCP context."
}

# --- Helper Aliases ---
alias ag = antigravity
alias g = git
alias p = podman