# https://github.com/Canop/broot/
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module broot %{
    require-module detection
    check-cmd broot

    define-command -docstring "use broot to find and open a file" broot %{
        evaluate-result "run() { ""%val{config}/scripts/broot"" ""$1"" '%sh{pwd}' ; } && run"
    }
}

provide-module fuzzyfind-broot %{
    require-module broot
    alias global fuzzyfind broot
}

provide-module filemanager-broot %{
    require-module broot
    alias global filemanager broot
}

hook -group broot global KakBegin .* %{
    require-module broot
}
