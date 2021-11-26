provide-module clipboard-xclip %{
    require-module detection
    check-cmd xclip
    set-option global clipboardcmd 'xclip -sel c'
}
