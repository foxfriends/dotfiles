hook global ModuleLoaded powerline %{ require-module powerline_icon_filetype }

provide-module powerline_icon_filetype %§

declare-option -hidden bool powerline_module_icon_filetype true
declare-option -hidden str powerline_icon_filetype_icon ''
set-option -add global powerline_modules 'icon_filetype'

define-command -hidden powerline-icon-filetype %{ evaluate-commands %sh{
    default=$kak_opt_powerline_base_bg
    next_bg=$kak_opt_powerline_next_bg
    normal=$kak_opt_powerline_separator
    thin=$kak_opt_powerline_separator_thin
    if [ "$kak_opt_powerline_module_icon_filetype" = "true" ]; then
        fg=$kak_opt_powerline_color10
        bg=$kak_opt_powerline_color11
        if [ ! -z "$kak_opt_filetype" ]; then
            [ "$next_bg" = "$bg" ] && separator="{$fg,$bg}$thin" || separator="{$bg,${next_bg:-$default}}$normal"
            printf "%s\n" "set-option -add global powerlinefmt %{$separator{$fg,$bg} %opt{filetype}}"
            if [ ! -z "$kak_opt_powerline_icon_filetype_icon" ]; then
                printf "%s\n" "set-option -add global powerlinefmt %{ $kak_opt_powerline_icon_filetype_icon}"
            fi
            printf "%s\n" "set-option -add global powerlinefmt %{ }"
            printf "%s\n" "set-option global powerline_next_bg $bg"
        fi
    fi
}}

define-command -hidden powerline-icon-filetype-setup-hooks %{
    remove-hooks global powerline-icon-filetype
    evaluate-commands %sh{
        if [ "$kak_opt_powerline_module_icon_filetype" = "true" ]; then
            printf "%s\n" "hook -group powerline-icon-filetype global WinDisplay .* %{ powerline-determine-icon-filetype; powerline-rebuild-buffer }"
            printf "%s\n" "hook -group powerline-icon-filetype global WinCreate .* %{ powerline-determine-icon-filetype; powerline-rebuild-buffer }"
            printf "%s\n" "hook -group powerline-icon-filetype global BufSetOption filetype=(.*) %{ powerline-determine-icon-filetype; powerline-rebuild-buffer }"
        fi
    }
}

define-command -hidden powerline-toggle-icon-filetype -params ..1 %{ evaluate-commands %sh{
    [ "$kak_opt_powerline_module_icon_filetype" = "true" ] && value=false || value=true
    if [ -n "$1" ]; then
        [ "$1" = "on" ] && value=true || value=false
    fi
    printf "%s\n" "set-option global powerline_module_icon_filetype $value"
}}

define-command -hidden powerline-determine-icon-filetype %{ set-option buffer powerline_icon_filetype_icon %sh{
    case "$kak_opt_filetype" in
        javascript)
            printf "%s\n" ''
            ;;
        rust)
            printf "%s\n" ''
            ;;
        *)
            printf "%s\n" ''
            ;;
    esac
}}

§
