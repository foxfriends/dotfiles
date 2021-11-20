# buffername: slightly modified version of the bufname module, that I think will look nicer.
# Notably, the context info is spaced from the file name, and may be disabled using the
# powerline_buffername_contextinfo option.

hook global ModuleLoaded powerline %{ require-module powerline_buffername }

provide-module powerline_buffername %§

declare-option -hidden bool powerline_module_buffername true
declare-option bool powerline_buffername_contextinfo true
set-option -add global powerline_modules 'buffername'

# Borrows this option from the original bufname module:
#
# declare-option -docstring "shorten the name of the buffer accordingly to the setting.
# full  - do not shorten buffer name: '/full/path/file'.
# short - display short path: '/f/p/file'.
# name  - only show the file name: 'file'." \
# str powerline_shorten_bufname "full"

define-command -hidden powerline-buffername %{ evaluate-commands %sh{
    default=$kak_opt_powerline_base_bg
    next_bg=$kak_opt_powerline_next_bg
    normal=$kak_opt_powerline_separator
    thin=$kak_opt_powerline_separator_thin
    if [ "$kak_opt_powerline_module_buffername" = "true" ]; then
        fg=$kak_opt_powerline_color00
        bg=$kak_opt_powerline_color03
        [ "$next_bg" = "$bg" ] && separator="{$fg,$bg}$thin" || separator="{$bg,${next_bg:-$default}}$normal"
        printf "%s\n" "set-option -add global powerlinefmt %{$separator{$fg,$bg} %opt{powerline_bufname}%opt{powerline_readonly2}}"
        if [ "$kak_opt_powerline_buffername_contextinfo" = "true" ]; then
        printf "%s\n" "set-option -add global powerlinefmt %{ {{context_info}}}"
        fi
        printf "%s\n" "set-option -add global powerlinefmt %{ }"
        printf "%s\n" "set-option global powerline_next_bg $bg"
    fi
}}

declare-option -hidden str powerline_readonly2
define-command -hidden powerline-update-readonly2 %{ set-option buffer powerline_readonly2 %sh{
    if [ ! "${kak_opt_readonly}" = "true" ]; then
        if [ -w "${kak_buffile}" ] || [ -z "${kak_buffile##*\**}" ]; then
            printf "%s\n" ''
            exit
        fi
    fi
    printf "%s\n" ' '
}}

define-command -hidden powerline-buffername-setup-hooks %{
    remove-hooks global powerline-buffername
    evaluate-commands %sh{
        if [ "$kak_opt_powerline_module_buffername" = "true" ]; then
            printf "%s\n" "hook -group powerline-buffername global WinDisplay .* %{ powerline-update-readonly2; powerline-update-bufname }"
            printf "%s\n" "hook -group powerline-buffername global BufWritePost .* %{ powerline-update-readonly2; powerline-update-bufname }"
            printf "%s\n" "hook -group powerline-buffername global BufSetOption readonly=.+ %{ powerline-update-readonly2; powerline-update-bufname }"
            printf "%s\n" "hook -group powerline-buffername global BufSetOption powerline_shorten_bufname=.+ %{ powerline-update-readonly2; powerline-update-bufname }"
        fi
    }
}

define-command -hidden powerline-toggle-buffername -params ..1 %{ evaluate-commands %sh{
    [ "$kak_opt_powerline_module_buffername" = "true" ] && value=false || value=true
    if [ -n "$1" ]; then
        [ "$1" = "on" ] && value=true || value=false
    fi
    printf "%s\n" "set-option global powerline_module_buffername $value"
}}

§
