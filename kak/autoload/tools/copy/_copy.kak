# Tool: copy
# ‾‾‾‾‾‾‾‾‾‾
# copy writes text to the system clipboard
declare-option -docstring "modules which provide a copy command" str-list copy_providers "copy-wl-copy" "copy-pbcopy" "copy-xclip"
declare-option -docstring "command to copy text to the system clipboard" str copycmd

map global user y ': nop %sh{printf "%s" "${kak_selection}" | ${kak_opt_copycmd}}<ret>' -docstring 'copy to system clipboard'
map global normal Y ': nop %sh{printf "%s" "${kak_selection}" | ${kak_opt_copycmd}}<ret>' -docstring 'copy to system clipboard'

hook -group copy global KakBegin .* %{
    require-module detection
    load-first %opt{copy_providers}
}
