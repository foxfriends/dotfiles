# https://github.com/BurntSushi/ripgrep
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module grep-rg %{
    require-module detection
    check-cmd rg

    set-option global grepcmd 'rg --vimgrep'
}
