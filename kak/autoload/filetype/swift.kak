hook global BufCreate .*[.](swift) %{
    set-option buffer filetype swift
}

hook global WinSetOption filetype=swift %{
    require-module swift
    hook window ModeChange pop:insert:.* -group swift-trim-indent swift-trim-indent
    hook window InsertChar \n -group swift-indent swift-indent-on-new-line
    hook window InsertChar \{ -group swift-indent swift-indent-on-opening-curly-brace
    hook window InsertChar [)}] -group swift-indent swift-indent-on-closing
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window swift-.+ }
}

hook -group swift-highlight global WinSetOption filetype=swift %{
    add-highlighter window/swift ref swift
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/swift }
}

provide-module swift %§
    add-highlighter shared/swift                        regions
    add-highlighter shared/swift/code                   default-region group
    add-highlighter shared/swift/string                 region %{(?<!')"} %{(?<!\\)(\\\\)*"} fill string
    add-highlighter shared/swift/multiline_string       region \
        %{"""} \
        %{"""} \
        fill string
    add-highlighter shared/swift/comment                region -recurse "/\*" "/\*" "\*/"    ref comment
    add-highlighter shared/swift/doc_comment            region "///" "$"                     ref doc_comment
    add-highlighter shared/swift/mark                   region "//\s*MARK:"  "$"             ref doc_comment
    add-highlighter shared/swift/line_comment           region "//"  "$"                     ref comment

    add-highlighter shared/swift/code/keyword group
    add-highlighter shared/swift/code/keyword/declaration     regex \b(associatedtype|class|deinit|enum|extension|func|init|inout|let|operator|protocol|rethrows|static|struct|subscript|typealias|var)\b 1:keyword
    add-highlighter shared/swift/code/keyword/visibility      regex \b(internal|public|private|fileprivate|open)\b 1:keyword
    add-highlighter shared/swift/code/keyword/expression      regex \b(as|Any|catch|nil|super|throw|throws|try)\b 1:keyword
    add-highlighter shared/swift/code/keyword/statement       regex \b(break|case|continue|default|defer|do|else|fallthrough|for|guard|if|in|repeat|return|switch|where|while)\b 1:keyword
    add-highlighter shared/swift/code/keyword/pattern         regex \b_\b 0:keyword
    add-highlighter shared/swift/code/keyword/preprocessor    regex "#(available|colorLiteral|column|else|elseif|endif|error|file|fileLiteral|function|if|imageLiteral|line|selector|sourceLocation|warning)\b" 1:meta
    add-highlighter shared/swift/code/keyword/contextual      regex \b(associativity|convenience|dynamic|didSet|final|get|infix|indirect|lazy|left|mutating|none|nonmutating|optional|override|postfix|precedence|prefix|Protocol|required|right|set|Type|unowned|weak|willSet)\b 1:keyword

    add-highlighter shared/swift/code/module_import           regex \b(import)\h+([a-zA-Z_][a-zA-Z_0-9]*(\.[a-zA-Z_][a-zA-Z_0-9]*)*)\b 1:keyword 2:module
    add-highlighter shared/swift/code/symbol_import           regex \b(import)\h+(typealias|struct|class|enum|protocol|let|var|func)\h+([a-zA-Z_][a-zA-Z_0-9]*(\.[a-zA-Z_][a-zA-Z_0-9]*)*)\.([a-zA-Z_][a-zA-Z_0-9]*)\b 1:keyword 2:keyword 3:module 4:identifier

    add-highlighter shared/swift/code/zero            regex \b(0)\b 1:value
    add-highlighter shared/swift/code/decimal-int     regex \b([1-9][0-9_]*)\b 1:value
    add-highlighter shared/swift/code/float           regex \b([1-9][0-9_]*(\.[0-9_]*)?(e[+-]?[1-9][0-9_]*)?)\b 1:value
    add-highlighter shared/swift/code/hex-int         regex \b(0x[0-9A-Fa-f_]+)\b 1:value
    add-highlighter shared/swift/code/octal-int       regex \b(0o[0-7_]+)\b 1:value
    add-highlighter shared/swift/code/binary-int      regex \b(0b[01_]+)\b 1:value
    add-highlighter shared/swift/code/bool            regex \b(true|false)\b 1:value
    add-highlighter shared/swift/code/case-shorthand  regex (?:\W)\.([a-zA-Z0-9_]+)\b 1:value

    add-highlighter shared/swift/code/type            regex \b([A-Z][A-Za-z0-9_]*)\b 1:type
    add-highlighter shared/swift/code/identifier      regex \b(self)\b 1:identifier
    add-highlighter shared/swift/code/anonymous-arg   regex \$[0-9]+\b 0:identifier
    add-highlighter shared/swift/code/raw_identifier  regex \b`([a-zA-Z0-9_])`\b 1:identifier
    add-highlighter shared/swift/code/operator        regex (\[|\]|=|==|!=|\+=|-=|\*=|/=|%=|~=|<|>|<=|>=|=>|->|\+|-|/|\*|%|~|\||\|\||&|&&|!|^|\?|<<|>>|<<=|>>=|:|::|\.|\.\.<|\.\.\.) 1:operator

    add-highlighter shared/swift/code/function             regex "\b([a-z][a-zA-Z_0-9]*)(\h*<[a-zA-Z_0-9\h:&,\.]+>)?\h*(?=\()" 1:function
    add-highlighter shared/swift/code/func-label-shorthand regex [(,]\h*([a-z][a-zA-Z_0-9]+): 1:builtin
    add-highlighter shared/swift/code/func-label-unnamed   regex [(,]\h*_\h+([a-z_][a-zA-Z_0-9]+): 1:identifier
    add-highlighter shared/swift/code/func-label-named     regex [(,]\h*([a-z][a-zA-Z_0-9]*)\h+([a-z_][a-zA-Z_0-9]+): 1:function 2:identifier

    add-highlighter shared/swift/code/attribute       regex (@[a-zA-Z][a-zA-Z0-9_]*)\b 1:keyword

    define-command -hidden swift-trim-indent %{
        # remove trailing white spaces
        try %{ execute-keys -draft -itersel x s \h+$ <ret> d }
    }

    define-command -hidden swift-indent-on-new-line %~
        evaluate-commands -draft -itersel %<
            # copy // comments prefix and following white spaces
            try %{ execute-keys -draft k x s ^\h*\K//[!/]?\h* <ret> y gh j P }
            # preserve previous line indent
            try %{ execute-keys -draft <semicolon> K <a-&> }
            # filter previous line
            try %{ execute-keys -draft k : swift-trim-indent <ret> }
            # indent after lines ending with { or (
            try %[ execute-keys -draft k x <a-k> [{(]\h*$ <ret> j <a-gt> ]
            # indent after lines ending with [{(].+ and move first parameter to own line
            try %< execute-keys -draft [c[({],[)}] <ret> <a-k> \A[({][^\n]+\n[^\n]*\n?\z <ret> L i<ret><esc> <gt> <a-S> <a-&> >
        >
    ~

    define-command -hidden swift-indent-on-opening-curly-brace %[
        evaluate-commands -draft -itersel %_
            # align indent with opening paren when { is entered on a new line after the closing paren
            try %[ execute-keys -draft h <a-F> ) M <a-k> \A\(.*\)\h*\n\h*\{\z <ret> s \A|.\z <ret> 1<a-&> ]
        _
    ]

    define-command -hidden swift-indent-on-closing %[
        evaluate-commands -draft -itersel %_
            # align to opening curly brace or paren when alone on a line
            try %< execute-keys -draft <a-h> <a-k> ^\h*[)}]$ <ret> h m <a-S> 1<a-&> >
        _
    ]
§
