provide-module clipboard-wl-copy %{
    require-module detection
    require-module wayland
    check-cmd wl-copy
    set-option global clipboardcmd 'wl-copy --foreground'
}
