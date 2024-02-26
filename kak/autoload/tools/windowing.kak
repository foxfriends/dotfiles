declare-option -docstring "modules which provide windowing facilities" \
    str-list windowing_providers "windowing-zellij" "windowing-tmux" "windowing-sway" "windowing-kitty"

hook -group windowing global KakBegin .* %{
    require-module detection
    load-first %opt{windowing_providers}
}
