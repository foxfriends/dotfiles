# http://tmux.github.io/
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

define-command -hidden is-tmux %{
    # ensure we're running under tmux
    evaluate-commands %sh{
        [ -n "$TMUX" ] || echo 'fail tmux not detected'
    }
}

provide-module tmux %{
    is-tmux

    define-command tmux -params 1.. -shell-completion -docstring 'tmux' %{
        nop %sh{
            tmux=${kak_client_env_TMUX:-$TMUX}
            TMUX=$tmux eval "tmux $@"
        }
    }

    define-command tmux-new-up -shell-completion -params 1.. -docstring '
    tmux-terminal-vertical <program> [<arguments>]: create a new terminal as a tmux pane
    The current pane is split into two, top and bottom
    The program passed as argument will be executed in the new terminal' %{
        tmux split-window -vb "%sh{""$kak_config/scripts/quote-all"" ""$@""}"
    }

    define-command tmux-new-down -shell-completion -params 1.. -docstring '
    tmux-terminal-vertical <program> [<arguments>]: create a new terminal as a tmux pane
    The current pane is split into two, top and bottom
    The program passed as argument will be executed in the new terminal' %{
        tmux split-window -v "%sh{""$kak_config/scripts/quote-all"" ""$@""}"
    }

    define-command tmux-new-right -params 1.. -shell-completion -docstring '
    tmux-terminal-horizontal <program> [<arguments>]: create a new terminal as a tmux pane
    The current pane is split into two, left and right
    The program passed as argument will be executed in the new terminal' %{
        tmux split-window -h "%sh{""$kak_config/scripts/quote-all"" ""$@""}"
    }

    define-command tmux-new-left -params 1.. -shell-completion -docstring '
    tmux-terminal-horizontal <program> [<arguments>]: create a new terminal as a tmux pane
    The current pane is split into two, left and right
    The program passed as argument will be executed in the new terminal' %{
        tmux split-window -hb "%sh{""$kak_config/scripts/quote-all"" ""$@""}"
    }

    define-command tmux-popup -params 1.. -shell-completion -docstring '
    tmux-popup <program> [<arguments>]: create a new terminal as a tmux popup
    The program passed as argument will be executed in the new terminal' %{
        tmux popup -w 80% -h 80% -E "%sh{""$kak_config/scripts/quote-all"" ""$@""}"
    }

    define-command tmux-new -params 1.. -shell-completion -docstring '
    tmux-terminal-window <program> [<arguments>] [<arguments>]: create a new terminal as a tmux window
    The program passed as argument will be executed in the new terminal' %{
        tmux new-window "%sh{""$kak_config/scripts/quote-all"" ""$@""}"
    }

    define-command tmux-focus -params ..1 -client-completion -docstring '
    tmux-focus [<client>]: focus the given client
    If no client is passed then the current one is used' \
    %{
        evaluate-commands %sh{
            if [ $# -eq 1 ]; then
                printf "evaluate-commands -client '%s' focus" "$1"
            elif [ -n "${kak_client_env_TMUX}" ]; then
                # select-pane makes the pane active in the window, but does not select the window. Both select-pane
                # and select-window should be invoked in order to select a pane on a currently not focused window.
                TMUX="${kak_client_env_TMUX}" tmux select-window -t "${kak_client_env_TMUX_PANE}" \; \
                                                   select-pane   -t "${kak_client_env_TMUX_PANE}" > /dev/null
            fi
        }
    }
}
