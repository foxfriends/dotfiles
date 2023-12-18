# https://www.prisma.io/
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](prisma) %{
    set-option buffer filetype prisma
    set buffer tabstop 2
    set buffer indentwidth 2
    set buffer formatcmd "%val{config}/scripts/prisma-fmt"
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=prisma %{
    require-module prisma

    hook window InsertChar .* -group prisma-indent prisma-indent-on-char
    hook window InsertChar \n -group prisma-insert prisma-insert-on-new-line
    hook window InsertChar \n -group prisma-indent prisma-indent-on-new-line

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window prisma-.+ }
}

hook -group prisma-highlight global WinSetOption filetype=prisma %{
    add-highlighter window/prisma ref prisma
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/prisma }
}


provide-module prisma %§
    # Highlighters
    # ‾‾‾‾‾‾‾‾‾‾‾‾

    add-highlighter shared/prisma regions
    add-highlighter shared/prisma/code default-region group
    add-highlighter shared/prisma/string           region %{(?<!')"} (?<!\\)(\\\\)*"              fill string
    add-highlighter shared/prisma/comment          region -recurse "/\*" "/\*" "\*/"              ref comment
    add-highlighter shared/prisma/doc_comment      region "///" "$"                            ref doc_comment
    add-highlighter shared/prisma/line_comment     region "//" "$"                                ref comment


    add-highlighter shared/prisma/code/ regex \b(model|generator|datasource)\b 0:keyword
    add-highlighter shared/prisma/code/ regex \b([a-z_][a-zA-Z_0-9]*)\s*(?=\() 1:function
    add-highlighter shared/prisma/code/ regex @@?(id|unique|relation|default|map|index)\b 0:keyword
    add-highlighter shared/prisma/code/ regex (@db\.|\b)([A-Z]\w*)\b 0:type
    add-highlighter shared/prisma/code/ regex \b(\w+): 1:meta
    add-highlighter shared/prisma/code/ regex -?\b[0-9_]+([eE][+-]?[0-9_]+)?\b 0:value
    add-highlighter shared/prisma/code/ regex -?\b[0-9_]*\.[0-9_]+([eE][+-]?[0-9_]+)?\b 0:value
    add-highlighter shared/prisma/code/ regex \b(true|false)\b 1:value

    # Commands
    # ‾‾‾‾‾‾‾‾

    define-command -hidden prisma-trim-indent %{
        # remove trailing white spaces
        try %{ execute-keys -draft -itersel x s \h+$ <ret> d }
    }

    define-command -hidden prisma-indent-on-new-line %~
        evaluate-commands -draft -itersel %<
            # copy // comments prefix and following white spaces
            try %{ execute-keys -draft k x s ^\h*\K//[!/]?\h* <ret> y gh j P }
            # preserve previous line indent
            try %{ execute-keys -draft <semicolon> K <a-&> }

            # filter previous line
            try %{ execute-keys -draft k : prisma-trim-indent <ret> }
            # indent after lines ending with { or (
            try %[ execute-keys -draft k x <a-k> [{(]\h*$ <ret> j <a-gt> ]
            # indent after lines ending with [{(].+
            # try %< execute-keys -draft [c[({],[)}] <ret> <a-k> L i<ret><esc> <gt> <a-S> <a-&> >
        >
    ~

    define-command -hidden prisma-indent-on-opening-curly-brace %[
        evaluate-commands -draft -itersel %_
            # align indent with opening paren when { is entered on a new line after the closing paren
            try %[ execute-keys -draft h <a-F> ) M <a-k> \A\(.*\)\h*\n\h*\{\z <ret> s \A|.\z <ret> 1<a-&> ]
        _
    ]

    define-command -hidden prisma-indent-on-closing %[
        evaluate-commands -draft -itersel %_
            # align to opening curly brace or paren when alone on a line
            try %< execute-keys -draft <a-h> <a-k> ^\h*[)}]$ <ret> h m <a-S> 1<a-&> >
        _
    ]
§
