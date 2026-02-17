# --- config.nu ---

# 1. Import your Container Commands
# Assuming containers.nu is in the same folder as this config file
use containers.nu * # 2. Keep the Health Check (This is still useful!)
let required_paths = [
    $"($env.HOME)/.kube",
    $"($env.HOME)/.ssh",
    $"($env.HOME)/.config/gcloud"
]

for path in $required_paths {
    if not ($path | path exists) {
        print $"[Health Check] Creating missing directory: ($path)"
        mkdir $path
    }
}