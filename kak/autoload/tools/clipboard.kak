declare-option -docstring "modules which provide a copy command" \
    str-list clipboard_providers "clipboard-bp" "clipboard-wl-copy" "clipboard-pbcopy" "clipboard-xclip"
declare-option -docstring "command to copy text to the system clipboard" \
    str clipboardcmd

define-command clipsel -docstring "copy selection to clipboard" %{
    nop %sh{
        printf '%s' "${kak_selection}" | (${kak_opt_clipboardcmd}) >/dev/null 2>&1 &
    }
}

map global normal Y ':clipsel<ret>'

hook -group clipboard global KakBegin .* %{
    require-module detection
    load-first %opt{clipboard_providers}
}
