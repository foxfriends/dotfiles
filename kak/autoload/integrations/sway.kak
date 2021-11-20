# https://swaywm.org/
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

define-command -hidden is-sway %{
    # ensure that we"re running in sway
    evaluate-commands %sh{
        [ -n "$SWAYSOCK" ] || echo "fail sway not detected"
    }
}

provide-module sway %{
    is-sway

    define-command -params 1.. swaymsg -docstring "swaymsg" %{
        nop %sh{ eval "swaymsg $@" }
    }

    define-command -params 1.. sway-float -docstring "sway-float" %{
        nop %sh{ sway-float "$@" & }
    }

    define-command sway-new -params 1 -shell-completion -docstring "Create a new window" %{
        swaymsg exec %sh{ "$kak_config/scripts/shell-quote" "$1" }
    }

    define-command sway-new-vertical -params 1 -shell-completion -docstring "Create a new window below" %{
        swaymsg split v, exec %sh{ "$kak_config/scripts/shell-quote" "$1" }
    }

    define-command sway-new-horizontal -params 1 -shell-completion -docstring "Create a new window on the right" %{
        swaymsg split h, exec %sh{ "$kak_config/scripts/shell-quote" "$1" }
    }

    define-command sway-new-tab -params 1 -shell-completion -docstring "Create a new window in a new tab" %{
        swaymsg split t, layout tabbed, exec %sh{ "$kak_config/scripts/shell-quote" "$1" }
    }

    define-command sway-terminal-horizontal -params .. -shell-completion -docstring "Create a new terminal on the right" %{
        sway-new-horizontal "%opt{termcmd} %sh{""$kak_config/scripts/quote-all"" ""$@""}"
    }

    define-command sway-terminal-vertical -params .. -shell-completion -docstring "Create a new terminal below" %{
        sway-new-vertical "%opt{termcmd} %sh{""$kak_config/scripts/quote-all"" ""$@""}"
    }

    define-command sway-terminal-tab -params .. -shell-completion -docstring "Create a new terminal in a new tab" %{
        sway-new-tab "%opt{termcmd} %sh{""$kak_config/scripts/quote-all"" ""$@""}"
    }

    define-command sway-terminal -params .. -shell-completion -docstring "Create a new terminal in the current container" %{
        sway-new "%opt{termcmd} %sh{""$kak_config/scripts/quote-all"" ""$@""}"
    }

    define-command sway-terminal-float -params .. -shell-completion -docstring "Create a new terminal in a floating window" %{
        sway-float "%opt{termcmd} %sh{""$kak_config/scripts/quote-all"" ""$@""}"
    }

    declare-user-mode sway
    map global sway n :sway-new<ret> -docstring "new window in the current container"
    map global sway t :sway-new-tab<ret> -docstring "new window in the current container"
    map global sway h :sway-new-horizontal<ret> -docstring "← new window on the left"
    map global sway l :sway-new-horizontal<ret> -docstring "→ new window on the right"
    map global sway k :sway-new-vertical<ret> -docstring "↑ new window above"
    map global sway j :sway-new-vertical<ret> -docstring "↓ new window below"
}

