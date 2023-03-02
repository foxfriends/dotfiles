# https://github.com/kamiyaa/joshuto
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module joshuto %{
    check-cmd joshuto
    define-command -docstring "use joshuto to find and open a file" joshuto %{
        set-register i %sh{
            if [ $(dirname "${kak_buffile}") = '.' ]; then
                pwd
            else
                dirname "${kak_buffile}"
            fi
        }
        evaluate-result "run() { ""%val{config}/scripts/joshuto"" ""$1"" '%reg{i}'; } && run"
    }
}

provide-module filemanager-joshuto %{
    require-module joshuto
    alias global filemanager joshuto
}

hook -group joshuto global KakBegin .* %{
    require-module joshuto
}
