# Tool: preview
# ‾‾‾‾‾‾‾‾‾‾‾‾‾
# preview shows a preview of a file, typically embedded into some other
# application that wants to show a preview.

declare-option -docstring 'command that outputs a preview of its input' \
    str previewcmd
declare-option -docstring 'modules that provide previewers' \
    str-list preview_providers "preview-syncat"

hook -group preview global KakBegin .* %{
    require-module detection
    load-first %opt{preview_providers}
}
