# https://github.com/Canop/broot/
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module broot %{
    require-module detection
    check-cmd broot

    define-command -docstring "use broot to find and open a file" broot %{
        evaluate-result "run () { broot --conf ""%val{config}/../broot/conf-kak.toml"" -G --outcmd ""$1"" ""%sh{pwd}""; } && run"
    }
}
