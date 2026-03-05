# --- config.nu ---

# --- System Editor Defaults ---
# This tells Git and your OS to use Antigravity instead of VS Code or Nano
$env.EDITOR = "antigravity"
$env.VISUAL = "antigravity"

# --- Google Secret Manager Loader ---
def --env load-cloud-secrets [] {
    # 1. Detect the current active gcloud project
    let default_pid = (^gcloud config get-value project | str trim)
    
    # 2. Create a dynamic prompt for the user
    let prompt_msg = if ($default_pid | is-empty) {
        "Please enter your Google Cloud Project ID: "
    } else {
        $"Please enter Google Cloud Project ID [Press Enter to use '($default_pid)']: "
    }

    # 3. Ask for input and trim any whitespace
    let user_input = (input $prompt_msg | str trim)

    # 4. Decide which project ID to use
    let pid = if ($user_input | is-empty) { $default_pid } else { $user_input }

    if ($pid | is-empty) {
        print "❌ Error: No project ID provided and no default gcloud project set."
        return
    }
    
    print $"🔒 Fetching secrets from Google Secret Manager [Project: ($pid)]..."

    # Fetch Gemini API Key (Updated to use gemini-api-key and masked errors!)
    let gemini_key = (^gcloud secrets versions access latest --secret "gemini-api-key" --project $pid err> /dev/null | str trim)
    if not ($gemini_key | is-empty) {
        $env.GEMINI_API_KEY = $gemini_key
    } else {
        print "⚠️ Warning: gemini-api-key not found."
    }

    # Fetch GitHub Token (Kept hyphen based on your gcloud output, and masked errors!)
    let gh_token = (^gcloud secrets versions access latest --secret "github-token" --project $pid err> /dev/null | str trim)
    if not ($gh_token | is-empty) {
        $env.GITHUB_TOKEN = $gh_token
    } else {
        print "⚠️ Warning: github-token not found."
    }

    print "✅ Secrets successfully loaded into RAM!"
}

# 2. Import your Container Commands
use ~/.config/nushell/containers.nu *

# 3. Keep the Health Check
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

# --- Aliases ---
# Launch Antigravity from the terminal
alias ag = antigravity
alias tf = terraform
alias ot = tofu