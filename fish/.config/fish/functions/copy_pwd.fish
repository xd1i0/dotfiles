function copy_pwd --description 'Copy current directory path to clipboard'
    printf '%s' "$PWD" | pbcopy
    echo "copied directory: $PWD"
end
