# user mode commands
map global user z ':w<ret>' -docstring 'save'
map global user w ':trim-eol<ret>' -docstring 'trim-eol'
map global user f ':format<ret>' -docstring 'format'
map global user p ':fuzzyfind<ret>' -docstring 'fuzzy find'
map global user '\' ':browse<ret>' -docstring 'browse files'
map global user / ':comment-line<ret>' -docstring 'comment'
map global user ` %{:set global lines_relative %sh{([ "$kak_opt_lines_relative" == 'false' ] && echo true) || echo false}<ret>} -docstring 'toggle relative line numbers'
