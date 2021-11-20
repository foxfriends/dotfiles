# Tool: filebrowser
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
# filebrowser finds files by allowing the user to explore them interactively

declare-option -docstring "modules that provide file browsers" \
    str-list filebrowser_providers "joshuto" "ranger" "broot"
declare-option -docstring "modules that bind file browser" \
    str-list filebrowser_binders "filebrowser-joshuto" "filebrowser-ranger" "filebrowser-broot"

hook -group filebrowser global KakBegin .* %{
    require-module detection
    load-all %opt{filebrowser_providers}
    load-first %opt{filebrowser_binders}
}
