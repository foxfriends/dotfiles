# https://github.com/sharkdp/fd
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module find-fd %{
    require-module detection
    check-cmd fd
    set-option global findcmd 'fd -t f'
}
