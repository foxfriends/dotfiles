# https://eslint.org/
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module lint-stylelint %{
    require-module detection
    check-cmd stylelint

    hook global WinSetOption filetype=(css) %{
        set buffer lintcmd 'run() { cat "$1" | stylelint --formatter json --stdin --stdin-filename "$kak_buffile" | "${kak_config}/scripts/stylelint-format"; } && run'
        lint-enable
    }
}
