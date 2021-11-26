provide-module wayland %{
    define-command is-wayland %{
        # ensure that we're running in the right environment
        evaluate-commands %sh{
            [ -z "${kak_opt_windowing_modules}" ] || [ -n "$WAYLAND_DISPLAY" ] || echo 'fail WAYLAND_DISPLAY is not set'
        }
    }

    is-wayland
}
