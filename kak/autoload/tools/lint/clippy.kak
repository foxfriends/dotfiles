# https://github.com/rust-lang/rust-clippy
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module lint-clippy %{
    require-module detection
    check-cmd clippy-driver

    hook global BufSetOption filetype=rust %{
        set-option buffer lintcmd 'cargo clippy'
    }
}
