provide-module ranger %{
    check-cmd ranger

    define-command -docstring "use ranger to find and open a file" ranger %{
        set-register i %sh{
            if [ $(dirname ${kak_buffile}) = '.' ]; then
                pwd
            else
                dirname ${kak_buffile}
            fi
        }
        evaluate-result "run() { ""%val{config}/scripts/ranger"" ""$1"" ""%reg{i}""; } && run"
    }
}
