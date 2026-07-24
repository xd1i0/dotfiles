function b -d "Fuzzy-find and checkout a branch"
  git branch -a | grep -v HEAD | string trim -c '* ' | string replace -r '^remotes/[^/]+/' '' | sort -u | fzf | read -l result; and git checkout "$result"
end
