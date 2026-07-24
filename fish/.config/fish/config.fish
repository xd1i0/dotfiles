# don't show the fish greeting
set fish_greeting ""

set -gx EDITOR nvim

# Homebrew (must come first so `brew` is available below)
fish_add_path --global /opt/homebrew/bin

# PATH (ported from ~/.zshrc)
fish_add_path --global /opt/homebrew/opt/openjdk@17/bin
fish_add_path --global /opt/homebrew/opt/ruby/bin
fish_add_path --global $HOME/.local/bin

# SDKMAN has no native fish support (github.com/sdkman/sdkman-cli/issues/671).
# `sdk` is a bash function, not a binary, so bass alone can't expose it —
# wrap each invocation in bash and re-import the resulting env via bass.
set -gx SDKMAN_DIR (brew --prefix sdkman-cli)/libexec
if test -s "$SDKMAN_DIR/bin/sdkman-init.sh"
    function sdk
        bass source "$SDKMAN_DIR/bin/sdkman-init.sh" ';' sdk $argv
    end
end

# git prompt styling
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showdirtystate yes
set -g __fish_git_prompt_char_stateseparator ' '
set -g __fish_git_prompt_char_dirtystate "✖"
set -g __fish_git_prompt_char_cleanstate "✔"
set -g __fish_git_prompt_char_untrackedfiles "…"
set -g __fish_git_prompt_char_stagedstate "●"
set -g __fish_git_prompt_char_conflictedstate "+"
set -g __fish_git_prompt_color_dirtystate white
set -g __fish_git_prompt_color_cleanstate white --bold
set -g __fish_git_prompt_color_invalidstate white
set -g __fish_git_prompt_color_branch white --dim

# Ghostty shell integration (working-directory tracking, etc.)
if test -d /Applications/Ghostty.app
    set -gx GHOSTTY_SHELL_INTEGRATION_XDG_DIR /Applications/Ghostty.app/Contents/Resources/ghostty/shell-integration
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
