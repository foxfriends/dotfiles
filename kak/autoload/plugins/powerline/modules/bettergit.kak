hook global ModuleLoaded powerline %{ require-module powerline_bettergit }

provide-module powerline_bettergit %§

set-option -add global powerline_modules 'bettergit'

declare-option -hidden bool powerline_module_bettergit true

define-command -hidden powerline-bettergit %{ evaluate-commands %sh{
    default=$kak_opt_powerline_base_bg
    next_bg=$kak_opt_powerline_next_bg
    normal=$kak_opt_powerline_separator
    thin=$kak_opt_powerline_separator_thin
    if [ "$kak_opt_powerline_module_bettergit" = "true" ]; then
        fg=$kak_opt_powerline_color02
        bg=$kak_opt_powerline_color04
        if [ -n "$kak_opt_powerline_branch" ]; then
            [ "$next_bg" = "$bg" ] && separator="{$fg,$bg}$thin" || separator="{$bg,${next_bg:-$default}}$normal"
            printf "%s\n" "set-option -add global powerlinefmt %{$separator{$fg,$bg} %opt{powerline_branch} }"
            printf "%s\n" "set-option global powerline_next_bg $bg"
            printf "%s\n" "powerline-update-branch"
        fi
    fi
}}

define-command -hidden powerline-bettergit-setup-hooks %{
    remove-hooks global powerline-bettergit
    evaluate-commands %sh{
        if [ "$kak_opt_powerline_module_bettergit" = "true" ]; then
            printf "%s\n" "hook -group powerline-bettergit global WinDisplay .* %{ powerline-update-branch; powerline-rebuild-buffer }"
            printf "%s\n" "hook -group powerline-bettergit global WinCreate .* %{ powerline-update-branch; powerline-rebuild-buffer }"
        fi
    }
}

define-command -hidden powerline-toggle-bettergit -params ..1 %{ evaluate-commands %sh{
    [ "$kak_opt_powerline_module_bettergit" = "true" ] && value=false || value=true
    if [ -n "$1" ]; then
        [ "$1" = "on" ] && value=true || value=false
    fi
    printf "%s\n" "set-option global powerline_module_bettergit $value"
}}

§
