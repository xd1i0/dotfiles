function copy_commandline --description 'Copy current command-line buffer to clipboard'
    set -l buf (commandline | string collect)
    printf '%s' "$buf" | pbcopy
    echo "copied command line: $buf"
end
