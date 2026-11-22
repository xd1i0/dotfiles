function dirty -d "Grid of uncommitted and unpushed work across git repos under ~/code"
    argparse h/help f/fetch 'n/max=!_validate_int --min 1' 'p/pattern=+' -- $argv; or return
    if set -q _flag_help
        echo "usage: dirty [-f|--fetch] [-n|--max N] [-p|--pattern GLOB]... [ROOT]"
        echo "  -f, --fetch    fetch all remotes first so ahead/behind is current"
        echo "  -n, --max      file lines shown per card (default 10)"
        echo "  -p, --pattern  only repos whose top-level dir under ROOT matches GLOB (repeatable)"
        return 0
    end

    set -l root ~/code
    set -q argv[1]; and set root (path resolve -- $argv[1])
    set -l max 10
    set -q _flag_max; and set max $_flag_max

    set -l c_n (set_color normal)
    set -l c_b (set_color --bold)
    set -l c_d (set_color brblack)
    set -l c_g (set_color green)
    set -l c_r (set_color red)
    set -l c_y (set_color yellow)
    set -l c_c (set_color cyan)
    set -l c_m (set_color magenta)
    set -l c_u (set_color blue)

    set -l repos (find $root -maxdepth 4 -name node_modules -prune -o -name .git -print 2>/dev/null | path dirname | sort -f)
    if set -q _flag_pattern
        set -l keep
        for repo in $repos
            set -l top (string split -f1 / -- (string replace -- "$root/" '' $repo))
            for p in $_flag_pattern
                string match -q -- $p $top; and set -a keep $repo; and break
            end
        end
        set repos $keep
    end
    if not set -q repos[1]
        echo "no git repos under $root"
        return 1
    end

    if set -q _flag_fetch
        for repo in $repos
            env GIT_TERMINAL_PROMPT=0 git -C $repo fetch --all --quiet 2>/dev/null &
        end
        wait
    end

    set -l clean
    set -l n 0
    for repo in $repos
        set -l rel (string replace -- "$root/" '' $repo)
        test "$repo" = "$root"; and set rel (path basename -- $root)
        set -l st (git -C $repo status --porcelain=v1 --branch 2>/dev/null); or continue
        set -l remotes (git -C $repo remote)
        set -l unpushed 0
        if set -q remotes[1]
            set unpushed (git -C $repo rev-list --count --branches --not --remotes 2>/dev/null; or echo 0)
        end
        if not set -q st[2]; and test $unpushed -eq 0
            set -a clean $rel
            continue
        end
        set n (math $n + 1)
        set -f repo_$n $repo
        set -f rel_$n $rel
        set -f head_$n $st[1]
        set -f files_$n $st[2..]
        set -f unpushed_$n $unpushed
        set -f remotes_$n (count $remotes)
    end

    if test $n -eq 0
        echo "$c_g✓$c_n everything under $c_b"(string replace -- ~ '~' $root)"$c_n is committed and pushed"
        return 0
    end

    set -l cols $COLUMNS
    set -l gap 2
    set -l minw 48
    set -l ncols (math "max(1, min($n, floor(($cols + $gap) / ($minw + $gap))))")
    set -l w (math "floor(($cols - $gap * ($ncols - 1)) / $ncols)")
    set -l inner (math $w - 4)

    for i in (seq $n)
        set -l v repo_$i; set -l repo $$v
        set -l v rel_$i; set -l rel $$v
        set -l v head_$i; set -l head $$v
        set -l v files_$i; set -l files $$v
        set -l v unpushed_$i; set -l unpushed $$v
        set -l v remotes_$i; set -l remotes $$v

        set -l branch (git -C $repo branch --show-current)
        test -n "$branch"; or set branch "@"(git -C $repo rev-parse --short HEAD 2>/dev/null)
        set -l tag $c_c$branch$c_n
        set -l ahead (string match -rg 'ahead (\d+)' -- $head)
        set -l behind (string match -rg 'behind (\d+)' -- $head)
        test -n "$ahead"; and set tag "$tag $c_m↑$ahead$c_n"
        test -n "$behind"; and set tag "$tag $c_r↓$behind$c_n"
        if not string match -q '*...*' -- $head; and test $remotes -gt 0
            set tag "$tag $c_d(no upstream)$c_n"
        end

        set -l left "$c_d╭─$c_n $c_b$rel$c_n "
        set -l right " $tag $c_d─╮$c_n"
        set -l fill (math $w - (string length --visible -- "$left") - (string length --visible -- "$right"))
        if test $fill -lt 1
            set rel (__dirty_fit (math (string length --visible -- $rel) + $fill - 1) left $rel)
            set left "$c_d╭─$c_n $c_b$rel$c_n "
            set fill 1
        end
        set -f title_$i "$left$c_d"(string repeat -n $fill ─)"$c_n$right"

        set -l staged 0
        set -l modified 0
        set -l untracked 0
        for f in $files
            set -l x (string sub -l 1 -- $f)
            set -l y (string sub -s 2 -l 1 -- $f)
            if test "$x$y" = '??'
                set untracked (math $untracked + 1)
                continue
            end
            test "$x" != ' '; and set staged (math $staged + 1)
            test "$y" != ' '; and set modified (math $modified + 1)
        end
        set -l stashes (git -C $repo stash list 2>/dev/null | count)

        set -l summary
        test $staged -gt 0; and set -a summary "$c_g●$c_n $staged staged"
        test $modified -gt 0; and set -a summary "$c_r●$c_n $modified modified"
        test $untracked -gt 0; and set -a summary "$c_u●$c_n $untracked untracked"
        test $unpushed -gt 0; and set -a summary "$c_m↑$c_n $unpushed unpushed"
        test $stashes -gt 0; and set -a summary "$c_d≡ $stashes stashed$c_n"
        test $remotes -eq 0; and set -a summary "$c_d(no remote)$c_n"

        set -l body (string join '  ' -- $summary)
        for f in $files[1..$max]
            set -l x (string sub -l 1 -- $f)
            set -l y (string sub -s 2 -l 1 -- $f)
            set -l code "$c_g$x$c_r$y$c_n"
            test "$x$y" = '??'; and set code "$c_u??$c_n"
            set -a body "$code "(__dirty_fit (math $inner - 3) left (string sub -s 4 -- $f))
        end
        set -l extra (math (count $files) - $max)
        test $extra -gt 0; and set -a body "$c_d… +$extra more$c_n"

        if test $unpushed -gt 0
            set -q files[1]; and set -a body $c_d(string repeat -n $inner ┈)$c_n
            for c in (git -C $repo log --branches --not --remotes --format='%h%x09%s' -n 3)
                set -l parts (string split -m1 \t -- $c)
                set -l subj (__dirty_fit (math $inner - 3 - (string length -- $parts[1])) right $parts[2])
                set -a body "$c_m↑$c_n $c_y$parts[1]$c_n $subj"
            end
            test $unpushed -gt 3; and set -a body "$c_d… +"(math $unpushed - 3)" more commits$c_n"
        end
        set -f body_$i $body
    end

    set -l out "$c_b"(string replace -- ~ '~' $root)"$c_n  $c_d·$c_n  $n with changes  $c_d·$c_n  "(count $clean)" clean" ''

    set -l sep (string repeat -n $gap ' ')
    set -l bottom "$c_d╰"(string repeat -n (math $w - 2) ─)"╯$c_n"
    for start in (seq 1 $ncols $n)
        set -l row (seq $start (math "min($start + $ncols - 1, $n)"))
        set -l h 0
        for i in $row
            set -l v body_$i
            set h (math "max($h, "(count $$v)")")
        end

        set -l segs
        for i in $row
            set -l v title_$i
            set -a segs $$v
        end
        set -a out (string join -- $sep $segs)

        for j in (seq $h)
            set -l segs
            for i in $row
                set -l v body_$i
                set -l lines $$v
                set -l content ''
                set -q lines[$j]; and set content $lines[$j]
                # held in a var: an empty substitution would collapse the whole concatenation
                set -l pad (string repeat -n (math $inner - (string length --visible -- "$content")) ' ')
                set -a segs "$c_d│$c_n $content$pad $c_d│$c_n"
            end
            set -a out (string join -- $sep $segs)
        end

        set -l segs
        for i in $row
            set -a segs $bottom
        end
        set -a out (string join -- $sep $segs)
    end

    if set -q clean[1]
        set -a out '' "$c_g✓$c_n $c_d"(string join ' · ' -- $clean)"$c_n"
    end

    if isatty stdout
        printf '%s\n' $out | less -RFX
    else
        printf '%s\n' $out
    end
end

function __dirty_fit -a width mode text
    set -l len (string length --visible -- $text)
    if test $len -le $width
        printf '%s\n' $text
    else if test "$mode" = left
        printf '%s\n' "…"(string sub -s (math $len - $width + 2) -- $text)
    else
        printf '%s\n' (string sub -l (math $width - 1) -- $text)"…"
    end
end
