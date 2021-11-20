# https://github.com/rust-lang/rustfmt
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module format-rustfmt %{
    require-module detection
    check-cmd rustfmt

    hook global BufSetOption filetype=rust %{
        set-option buffer formatcmd 'rustfmt'
    }
}
