# Random commands I like to keep around!

define-command trim-eol -docstring 'trim whitespace from end of lines' %{
    try %{
        execute-keys -draft %{%%s +$<ret><a-d>}
    } catch %{}
}

define-command -docstring 'set buffer filetype <type>' -params 1 sf %{
    set buffer filetype %arg{1}
}
