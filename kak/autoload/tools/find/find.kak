# https://man7.org/linux/man-pages/man1/find.1.html
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module find-find %{
    require-module detection
    check-cmd find
    set-option global findcmd 'find -type f'
}
