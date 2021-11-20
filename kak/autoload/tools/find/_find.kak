# Tool: find
# ‾‾‾‾‾‾‾‾‾‾
# find searches for files

declare-option -docstring "modules which implement a find provider" \
    str-list find_providers 'find-fd' 'find-find'
declare-option -docstring "command to perform find" str findcmd

define-command find -params 1 -shell-script-candidates %{ $kak_opt_findcmd } %{ edit %arg{1} }

hook -group find global KakBegin .* %{
    require-module detection
    load-first %opt{find_providers}
}
