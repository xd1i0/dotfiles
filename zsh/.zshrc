export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

autoload -Uz compinit && compinit

# Load Angular CLI autocompletion.
source <(ng completion script)

export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# Created by `pipx` on 2026-03-31 06:19:19
export PATH="$PATH:/Users/daniel/.local/bin"
