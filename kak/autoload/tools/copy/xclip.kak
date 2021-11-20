provide-module copy-xclip %{
    require-module detection
    check-cmd xclip
    set-option global copycmd 'xclip -sel c'
}
