function c -d "Fuzzy-find and cd into a project under ~/code"
    set -l directory (command ls -d -1 ~/code/*/ 2>/dev/null | fzf --tiebreak=length,begin,end)
    if test -n "$directory"
        cd $directory
    end
end
