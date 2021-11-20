# Tool: terminal
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

declare-option -docstring "modules which provide a terminal command" str-list terminal_providers "terminal-kitty"

hook -group terminal global KakBegin .* %{
    require-module detection
    load-first %opt{terminal_providers}
}
