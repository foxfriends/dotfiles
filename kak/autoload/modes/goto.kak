map global goto s '<esc>: open-related<ret>' -docstring 'cycle related files (existing)'

map global goto d <esc>:lsp-definition<ret> -docstring 'LSP definition'
map global goto r <esc>:lsp-references<ret> -docstring 'LSP references'
map global goto y <esc>:lsp-type-definition<ret> -docstring 'LSP type definition'

map global object l '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
map global object <a-l> '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
map global object F '<a-semicolon>lsp-object Function Method<ret>' -docstring 'LSP function or method'
map global object T '<a-semicolon>lsp-object Class Interface Module Namespace Struct<ret>' -docstring 'LSP class or module'
map global object d '<a-semicolon>lsp-diagnostic-object error warning<ret>' -docstring 'LSP errors and warnings'
map global object D '<a-semicolon>lsp-diagnostic-object error<ret>' -docstring 'LSP errors'
