# http://zellij.dev/
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module zellij %{
    evaluate-commands %sh{ [ -n "$ZELLIJ" ] || echo 'fail zellij not detected' }

    define-command zellij -params 1.. -shell-completion -docstring 'zellij' %{
        nop %sh{
            zellij=${kak_client_env_ZELLIJ:-$ZELLIJ}
            ZELLIJ=$zellij eval "zellij $@"
        }
    }

    define-command zellij-new-up -shell-completion -params 1.. -docstring '
    zellij-terminal-up <program> [<arguments>]: create a new terminal as a zellij pane
    The current pane is split into two, top and bottom
    The program passed as argument will be executed in the new terminal' %{
        zellij action new-pane -c -d up -- "%sh{""$kak_config/scripts/quote-all"" ""$@""}"
    }

    define-command zellij-new-down -shell-completion -params 1.. -docstring '
    zellij-terminal-down <program> [<arguments>]: create a new terminal as a zellij pane
    The current pane is split into two, top and bottom
    The program passed as argument will be executed in the new terminal' %{
        zellij action new-pane -c -d down -- "%sh{""$kak_config/scripts/quote-all"" ""$@""}"
    }

    define-command zellij-new-right -params 1.. -shell-completion -docstring '
    zellij-terminal-right <program> [<arguments>]: create a new terminal as a zellij pane
    The current pane is split into two, left and right
    The program passed as argument will be executed in the new terminal' %{
        zellij action new-pane -c -d right -- "%sh{""$kak_config/scripts/quote-all"" ""$@""}"
    }

    define-command zellij-new-left -params 1.. -shell-completion -docstring '
    zellij-terminal-left <program> [<arguments>]: create a new terminal as a zellij pane
    The current pane is split into two, left and right
    The program passed as argument will be executed in the new terminal' %{
        zellij action new-pane -c -d left -- "%sh{""$kak_config/scripts/quote-all"" ""$@""}"
    }

    define-command zellij-popup -params 1.. -shell-completion -docstring '
    zellij-popup <program> [<arguments>]: create a new terminal as a zellij popup
    The program passed as argument will be executed in the new terminal' %{
        zellij action new-pane -c -f -- "%sh{""$kak_config/scripts/quote-all"" ""$@""}"
    }

    define-command zellij-new -params 1.. -shell-completion -docstring '
    zellij-terminal-window <program> [<arguments>] [<arguments>]: create a new terminal as a zellij window
    The program passed as argument will be executed in the new terminal' %{
        zellij new-tab -- "%sh{""$kak_config/scripts/quote-all"" ""$@""}"
    }

    # define-command zellij-focus -params ..1 -client-completion -docstring '
    # zellij-focus [<client>]: focus the given client
    # If no client is passed then the current one is used' \
    # %{
    #     evaluate-commands %sh{
    #         if [ $# -eq 1 ]; then
    #             printf "evaluate-commands -client '%s' focus" "$1"
    #         elif [ -n "${kak_client_env_TMUX}" ]; then
    #             # select-pane makes the pane active in the window, but does not select the window. Both select-pane
    #             # and select-window should be invoked in order to select a pane on a currently not focused window.
    #             ZELLIJ="${kak_client_env_TMUX}" zellij select-window -t "${kak_client_env_TMUX_PANE}" \; \
    #                                                select-pane   -t "${kak_client_env_TMUX_PANE}" > /dev/null
    #         fi
    #     }
    # }
}

provide-module windowing-zellij %{
    require-module zellij

    alias global terminal       zellij-new
    alias global terminal-popup zellij-popup
    alias global terminal-tab   zellij-new
    alias global terminal-left  zellij-new-left
    alias global terminal-right zellij-new-right
    alias global terminal-above zellij-new-up
    alias global terminal-below zellij-new-down
    # alias global focus          zellij-focus
}

hook -group zellij global KakBegin .* %{
    require-module zellij
}
