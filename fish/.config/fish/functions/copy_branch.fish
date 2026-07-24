function copy_branch --description 'Copy current git branch name to clipboard'
    set -l branch (git_branch_name)
    test -z "$branch"; and return
    printf '%s' "$branch" | pbcopy
    echo "copied branch: $branch"
end
