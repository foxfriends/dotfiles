 # Detection

hook global BufCreate .*[.](ron) %{
    set-option buffer filetype ron
}

# Initialization

hook global WinSetOption filetype=ron %[
    require-module ron
    hook window ModeChange pop:insert:.* -group ron-trim-indent ron-trim-indent
    hook window InsertChar \n -group ron-indent ron-indent-on-new-line
    hook window InsertChar \{ -group ron-indent ron-indent-on-opening-curly-brace
    hook window InsertChar [)}] -group ron-indent ron-indent-on-closing
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window ron-.+ }
]

hook -group ron-highlight global WinSetOption filetype=ron %{
    add-highlighter window/ron ref ron
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/ron }
}

provide-module ron %§

# Highlighters

add-highlighter shared/ron                  regions
add-highlighter shared/ron/code             default-region group
add-highlighter shared/ron/comment_l        region "//" "$"                                ref comment
add-highlighter shared/ron/comment_b        region -recurse "/\*" "/\*" "\*/"              ref comment
add-highlighter shared/ron/string           region %{(?<!')"} (?<!\\)(\\\\)*"              fill string
add-highlighter shared/ron/raw_string       region -match-capture %{(?<!')r(#*)"} %{"(#*)} fill string
add-highlighter shared/ron/attribute        region "#!?\[" "\]"                            fill keyword

add-highlighter shared/ron/code/            regex \b([a-z_][a-zA-Z0-9_]*)\s+:       1:meta
add-highlighter shared/ron/code/            regex \b([A-Z]+[a-zA-Z0-9_]*)\b           1:type
add-highlighter shared/ron/code/            regex \b((\+|-)?((([0-9][0-9_]*)?(\.[0-9_]+)?([eE][0-9]+)?)|0x[0-9a-fA-F][0-9a-fA-F_]*|0b[01][01_]*|0o[0-7][0-7]*))\b            1:value
add-highlighter shared/ron/code/            regex ('([^'\\]|\\'|\\\\|\\u\{[0-9a-fA-F]{1,4}\})') 1:value
add-highlighter shared/ron/code/            regex \b(true|false)\b 1:value

define-command -hidden ron-trim-indent %{
    # remove trailing white spaces
    try %{ execute-keys -draft -itersel <a-x> s \h+$ <ret> d }
}

define-command -hidden ron-indent-on-new-line %~
    evaluate-commands -draft -itersel %<
        # copy // comments prefix and following white spaces
        try %{ execute-keys -draft k <a-x> s ^\h*\K//[!/]?\h* <ret> y gh j P }
        # preserve previous line indent
        try %{ execute-keys -draft <semicolon> K <a-&> }
        
        # filter previous line
        try %{ execute-keys -draft k : ron-trim-indent <ret> }
        # indent after lines ending with { or (
        try %[ execute-keys -draft k <a-x> <a-k> [{(]\h*$ <ret> j <a-gt> ]
        # indent after lines ending with [{(].+
        # try %< execute-keys -draft [c[({],[)}] <ret> <a-k> L i<ret><esc> <gt> <a-S> <a-&> >
    >
~

define-command -hidden ron-indent-on-opening-curly-brace %[
    evaluate-commands -draft -itersel %_
        # align indent with opening paren when { is entered on a new line after the closing paren
        try %[ execute-keys -draft h <a-F> ) M <a-k> \A\(.*\)\h*\n\h*\{\z <ret> s \A|.\z <ret> 1<a-&> ]
    _
]

define-command -hidden ron-indent-on-closing %[
    evaluate-commands -draft -itersel %_
        # align to opening curly brace or paren when alone on a line
        try %< execute-keys -draft <a-h> <a-k> ^\h*[)}]$ <ret> h m <a-S> 1<a-&> >
    _
]§
