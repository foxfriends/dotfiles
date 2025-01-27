# unicode: the unicode codepoint of the character under the cursor

provide-module powerline_unicode %§

declare-option -hidden bool powerline_module_unicode true
set-option -add global powerline_modules 'unicode'

define-command -hidden powerline-unicode %{ evaluate-commands %sh{
    default=$kak_opt_powerline_base_bg
    next_bg=$kak_opt_powerline_next_bg
    normal=$kak_opt_powerline_separator
    thin=$kak_opt_powerline_separator_thin
    if [ "$kak_opt_powerline_module_unicode" = "true" ]; then
        fg=$kak_opt_powerline_color19
        bg=$kak_opt_powerline_color18
        [ "$next_bg" = "$bg" ] && separator="{$fg,$bg}$thin" || separator="{$bg,${next_bg:-$default}}$normal"
        printf "%s\n" "set-option -add global powerlinefmt %{$separator{$fg,$bg} U+%sh{printf '%04x' \"\$kak_cursor_char_value\"} }"
        printf "%s\n" "set-option global powerline_next_bg $bg"
    fi
}}

define-command -hidden powerline-unicode-setup-hooks %{}

define-command -hidden powerline-toggle-unicode -params ..1 %{ evaluate-commands %sh{
    [ "$kak_opt_powerline_module_unicode" = "true" ] && value=false || value=true
    if [ -n "$1" ]; then
        [ "$1" = "on" ] && value=true || value=false
    fi
    printf "%s\n" "set-option global powerline_module_unicode $value"
}}

§

hook global ModuleLoaded powerline %{ require-module powerline_unicode }
