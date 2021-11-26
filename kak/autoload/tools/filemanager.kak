declare-option -docstring "modules that provide a filemanager command" \
    str-list filemanager_providers "filemanager-joshuto" "filemanager-broot"

hook -group filemanager global KakBegin .* %{
    require-module detection
    load-first %opt{filemanager_providers}
}
