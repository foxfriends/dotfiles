# https://github.com/casey/just
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook -group grep global KakBegin .* %{
    require-module detection
    try %{
        check-cmd just
        define-command -docstring "use just to run a command" -params .. just %{
            info %sh{just $@ 2>&1}
        }
    } catch %{ echo -debug "no just %val{error}" }
}

