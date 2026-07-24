function c -d "Fuzzy-find and cd into a project under ~/code"
    if not test -d ~/code
        echo "~/code does not exist"
        return 1
    end
    set -l dirs ~/code/*/
    if not set -q dirs[1]
        echo "~/code is empty"
        return 1
    end
    set -l directory (ls -dt $dirs | head -10 | fzf --tiebreak=length,begin,end)
    if test -n "$directory"
        cd $directory
    end
end
