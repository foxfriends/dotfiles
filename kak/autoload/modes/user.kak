define-command trim-eol -docstring 'trim whitespace from end of lines' %{
    try %{
        execute-keys -draft %{%%s +$<ret><a-d>}
    } catch %{}
}

define-command toggle-relative-lines -docstring 'toggle relative line numbers' %{
    set global lines_relative %sh{
        ([ "$kak_opt_lines_relative" == 'false' ] && echo true) || echo false
    }
}

map global user z ':w<ret>' -docstring 'save'
map global user w ':trim-eol<ret>' -docstring 'trim-eol'
map global user f ':format<ret>' -docstring 'format'
map global user p ':fuzzyfind<ret>' -docstring 'fuzzy find'
map global user '\' ':filemanager<ret>' -docstring 'browse files'
map global user / ':comment-line<ret>' -docstring 'comment'
map global user ` ':toggle-relative-lines<ret>' -docstring 'toggle relative line numbers'
map global user y ':clipsel<ret>' -docstring 'copy to clipboard'
