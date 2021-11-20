provide-module copy-pbcopy %{
    require-module detection
    check-cmd pbcopy
    set-option global copycmd 'pbcopy'
}
