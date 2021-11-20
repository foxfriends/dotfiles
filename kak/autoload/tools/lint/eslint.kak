# https://eslint.org/
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module lint-eslint %{
    require-module detection
    check-cmd eslint
    check-file %sh{echo "$(npm root -g)/eslint-formatter-kakoune/index.js"}

    hook global WinSetOption filetype=(javascript|typescript) %{
        set buffer lintcmd 'run() { cat "$1" | eslint -f "$(npm root -g)/eslint-formatter-kakoune/index.js" --stdin --stdin-filename "$kak_buffile"; } && run'
        lint-enable
    }
}
