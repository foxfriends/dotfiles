declare-user-mode modes
map global modes k ':enter-user-mode windowing<ret>' -docstring 'windowing'
map global modes v 'v' -docstring 'view'
map global modes V 'V' -docstring 'view (lock)'
map global modes g ':enter-user-mode git<ret>' -docstring 'git'
map global modes <space> ':enter-user-mode user<ret>' -docstring 'user'
map global modes l ':enter-user-mode lsp<ret>' -docstring 'lsp'

hook -group pastel global KakBegin .* %{
    require-module pastel
    map global modes c ':enter-user-mode pastel<ret>' -docstring 'pastel'
}
