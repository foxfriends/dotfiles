# https://sw.kovidgoyal.net/kitty/index.html
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

define-command -hidden is-kitty %{
    # ensure that we're running on kitty
    evaluate-commands %sh{
        [ "$TERM" = "xterm-kitty" ] || echo 'fail kitty not detected'
    }
}

provide-module kitty %{
    is-kitty

    define-command kitty -params .. -shell-completion -docstring 'kitty' %{
        nop %sh{
            kitty -1 "$@" > /dev/null 2>&1
        }
    }

    define-command at-kitty -params 1.. -shell-completion -docstring 'kitty @' %{
        nop %sh{
            if [ -z "$kak_client_env_KITTY_LISTEN_ON" ]; then
                kitty @ "$@" > /dev/null 2>&1
            else
                kitty @ --to "$kak_client_env_KITTY_LISTEN_ON" "$@" > /dev/null 2>&1
            fi
        }
    }

    define-command kitty-new -params 1.. -shell-completion -docstring '
    kitty-terminal <program> [<arguments>]: create a new terminal as a kitty window
    The program passed as argument will be executed in the new terminal' %{
        at-kitty launch --no-response --copy-env --env "PATH=%sh{echo $PATH}" --type window --cwd "%sh{pwd}" %arg{@}
    }

    define-command kitty-new-tab -params 1.. -shell-completion -docstring '
    kitty-terminal-tab <program> [<arguments>]: create a new terminal as kitty tab
    The program passed as argument will be executed in the new terminal' %{
        at-kitty launch --no-response --copy-env --env "PATH=%sh{echo $PATH}" --type tab --cwd "%sh{pwd}" %arg{@}
    }

    define-command kitty-focus -params ..1 -client-completion -docstring '
    kitty-focus [<client>]: focus the given client
    If no client is passed then the current one is used' \
    %{
        evaluate-commands %sh{
            if [ $# -eq 1 ]; then
                printf "evaluate-commands -client '%s' focus" "$1"
            else
                if [ -z "$kak_client_env_KITTY_LISTEN_ON" ]; then
                    kitty @ focus-tab --no-response -m=id:$kak_client_env_KITTY_WINDOW_ID
                    kitty @ focus-window --no-response -m=id:$kak_client_env_KITTY_WINDOW_ID
                else
                    kitty @ --to "$kak_client_env_KITTY_LISTEN_ON" focus-tab --no-response -m=id:$kak_client_env_KITTY_WINDOW_ID
                    kitty @ --to "$kak_client_env_KITTY_LISTEN_ON" focus-window --no-response -m=id:$kak_client_env_KITTY_WINDOW_ID
                fi
            fi
        }
    }

    define-command kitty-new-horizontal -params 1.. -shell-completion %{
        at-kitty launch --no-response --location vsplit --cwd "%sh{pwd}" %arg{@}
    }

    define-command kitty-new-vertical -params 1.. -shell-completion %{
        at-kitty launch --no-response --location hsplit --cwd "%sh{pwd}" %arg{@}
    }
}
