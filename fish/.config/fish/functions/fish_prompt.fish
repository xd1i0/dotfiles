function fish_prompt
    echo -n -s (set_color white --bold) (prompt_pwd)(set_color normal) (fish_git_prompt) (set_color white) " > " (set_color normal)
end
