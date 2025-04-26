# https://yazi-rs.github.io/
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module yazi %{
    check-cmd yazi
    define-command -docstring "use yazi to find and open a file" yazi %{
        set-register i %sh{
            if [ $(dirname "${kak_buffile}") = '.' ]; then
                pwd
            else
                dirname "${kak_buffile}"
            fi
        }
        evaluate-result "run() { ""%val{config}/scripts/yazi"" ""$1"" '%reg{i}' ; } && run"
    }
}

provide-module filemanager-yazi %{
    require-module yazi
    alias global filemanager yazi
}

hook -group yazi global KakBegin .* %{
    require-module yazi
}
