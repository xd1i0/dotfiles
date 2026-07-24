function f -d "Fuzzy-find and open a file in nvim"
  set -l selected (fd --type f --hidden --exclude .git | fzf --height 40% --info inline --border --reverse --preview 'cat {}')
  if test -n "$selected"
    nvim $selected
  end
end
