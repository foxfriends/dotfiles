# Tool: windowing
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
# Attempt to detect the windowing environment(s) we"re operating under
#
# We try to load windowing environments from the `windowing_modules`
# option.
#
# These modules should both begin by attempting to detect whether it"s relevant
# windowing environment is actually in use. If not, `fail` should be run to
# prevent the rest of the module from loading.
#
# Next, a primary windowing module is attached by running the modules in
# `windowing_providers` option. Once one of them has succeeded, the rest
# will be skipped.
#
# Each module is expected to bind as many of the following aliases as possible:
# *   terminal          - create a new terminal with sensible defaults
# *   terminal-tab      - create a new terminal in a tab
# *   terminal-left     - create a new terminal to the left
# *   terminal-right    - create a new terminal to the right
# *   terminal-above    - create a new terminal above
# *   terminal-below    - create a new terminal belo
# *   focus             - focus the specified (defaulting to current) client

declare-option -docstring \
"Command to open a new terminal. Should accept another command to be run in
that terminal as a parameter" \
str termcmd

declare-option -docstring 'modules that interact with windowing environments' \
    str-list windowing_modules "tmux" "sway" "kitty"

declare-option -docstring 'modules that provide a primary windowing environment' \
    str-list windowing_providers "windowing-tmux" "windowing-sway" "windowing-kitty"

hook -group windowing global KakBegin .* %{
    require-module detection
    load-all %opt{windowing_modules}
    load-first %opt{windowing_providers}
}

declare-user-mode windowing
map global windowing h ":terminal-left %sh{which kak} -c %val{session} <ret>" -docstring "split left"
map global windowing l ":terminal-right %sh{which kak} -c %val{session} <ret>" -docstring "split right"
map global windowing k ":terminal-above %sh{which kak} -c %val{session} <ret>" -docstring "split above"
map global windowing j ":terminal-below %sh{which kak} -c %val{session} <ret>" -docstring "split below"
