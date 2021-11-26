provide-module clipboard-pbcopy %{
    require-module detection
    check-cmd pbcopy
    set-option global clipboardcmd 'pbcopy'
}
