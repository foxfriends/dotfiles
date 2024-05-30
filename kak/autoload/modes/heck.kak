declare-user-mode heck
map global heck s ':enter-user-mode heck-snake<ret>' -docstring 'snake to...'
map global heck c ':enter-user-mode heck-camel<ret>' -docstring 'camel to...'
map global heck k ':enter-user-mode heck-kebab<ret>' -docstring 'kebab to...'
map global heck t ':enter-user-mode heck-title<ret>' -docstring 'title to...'

declare-user-mode heck-snake
map global heck-snake c '|ccase -f snake -t camel | tr -d "\n" <ret>' -docstring 'camel'
map global heck-snake k '|ccase -f snake -t kebab | tr -d "\n" <ret>' -docstring 'kebab'
map global heck-snake p '|ccase -f snake -t pascal | tr -d "\n" <ret>' -docstring 'pascal'
map global heck-snake t '|ccase -f snake -t title | tr -d "\n" <ret>' -docstring 'title'

declare-user-mode heck-camel
map global heck-camel s '|ccase -f camel -t snake | tr -d "\n" <ret>' -docstring 'snake'
map global heck-camel k '|ccase -f camel -t kebab | tr -d "\n" <ret>' -docstring 'kebab'
map global heck-camel p '|ccase -f camel -t pascal | tr -d "\n" <ret>' -docstring 'pascal'
map global heck-camel t '|ccase -f camel -t title | tr -d "\n" <ret>' -docstring 'title'

declare-user-mode heck-title
map global heck-title s '|ccase -f title -t snake | tr -d "\n" <ret>' -docstring 'snake'
map global heck-title k '|ccase -f title -t kebab | tr -d "\n" <ret>' -docstring 'kebab'
map global heck-title p '|ccase -f title -t pascal | tr -d "\n" <ret>' -docstring 'pascal'
map global heck-title c '|ccase -f title -t camel | tr -d "\n" <ret>' -docstring 'camel'

declare-user-mode heck-kebab
map global heck-kebab s '|ccase -f kebab -t snake | tr -d "\n" <ret>' -docstring 'snake'
map global heck-kebab t '|ccase -f kebab -t title | tr -d "\n" <ret>' -docstring 'title'
map global heck-kebab p '|ccase -f kebab -t pascal | tr -d "\n" <ret>' -docstring 'pascal'
map global heck-kebab c '|ccase -f kebab -t camel | tr -d "\n" <ret>' -docstring 'camel'
