# https://rhai.rs
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](rhai) %{
    set-option buffer filetype rhai
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=rhai %[
    require-module rhai

    hook window ModeChange pop:insert:.* -group rhai-trim-indent rhai-trim-indent
    hook window InsertChar \n -group rhai-indent rhai-indent-on-new-line
    hook window InsertChar \{ -group rhai-indent rhai-indent-on-opening-curly-brace
    hook window InsertChar [)}] -group rhai-indent rhai-indent-on-closing
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window rhai-.+ }
]

hook -group rhai-highlight global WinSetOption filetype=rhai %{
    add-highlighter window/rhai ref rhai
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/rhai }
}

provide-module rhai %§
    # Highlighters
    # ‾‾‾‾‾‾‾‾‾‾‾‾
    add-highlighter shared/rhai regions
    add-highlighter shared/rhai/code default-region group

    add-highlighter shared/rhai/string           region %{(?<!')"} (?<!\\)(\\\\)*"              fill string
    add-highlighter shared/rhai/raw_string       region -match-capture %{(?<!')r(#*)"} %{"(#*)} fill string
    add-highlighter shared/rhai/doc_comment      region -recurse "/\**" "/\*" "\*/"             ref doc_comment
    add-highlighter shared/rhai/comment          region -recurse "/\*" "/\*" "\*/"              ref comment
    add-highlighter shared/rhai/doc_line_comment region "///" "$"                               ref doc_comment
    add-highlighter shared/rhai/line_comment     region "//" "$"                                ref comment

    add-highlighter shared/rhai/shebang          region ^#!  $                       fill meta

    add-highlighter shared/rhai/literal           region "`"  (?<!\\)(\\\\)*`         regions
    add-highlighter shared/rhai/literal/string                  default-region group
    add-highlighter shared/rhai/literal/string/                 fill string
    add-highlighter shared/rhai/literal/interpolation           region -recurse \{ \$\{   \}  regions
    add-highlighter shared/rhai/literal/interpolation/          default-region fill interpolation
    add-highlighter shared/rhai/literal/interpolation/content   region -recurse \{ \$\{\K   (?=\})  ref rhai

    add-highlighter shared/rhai/code/operator     regex (\[|\]|=|==|!=|\+=|-=|\*=|/=|%=|<|>|<=|>=|=>|->|\+|-|/|\*|%|~|\||\|\||&|&&|!|\^|\?|<<|>>|<<=|>>=|\.|\.\.|\.\.=) 1:operator
    add-highlighter shared/rhai/code/scope        regex (:) 1:default+fd
    add-highlighter shared/rhai/code/builtin      regex \b(type_of|call|curry|is_def_fn|is_def_var|print|debug|eval|Fn)\b 1:meta

    add-highlighter shared/rhai/code/zero         regex \b0\b 1:value
    add-highlighter shared/rhai/code/decimal-int  regex \b([1-9][0-9_]*)\b 1:value
    add-highlighter shared/rhai/code/float        regex \b([1-9][0-9_]*(\.[0-9_]*)?(e[+-]?[1-9][0-9_]*)?)\b 1:value
    add-highlighter shared/rhai/code/hex-int      regex \b(0x[0-9A-Fa-f_]+)\b 1:value
    add-highlighter shared/rhai/code/octal-int    regex \b(0o[0-7_]+)\b 1:value
    add-highlighter shared/rhai/code/binary-int   regex \b(0b[01_]+)\b 1:value
    add-highlighter shared/rhai/code/character    regex ('([^'\\]|\\'|\\\\|\\u\{[0-9a-fA-F]{1,4}\})') 1:value
    add-highlighter shared/rhai/code/bool         regex \b(true|false)\b 1:value

    add-highlighter shared/rhai/code/namespace    regex \b([a-z][a-zA-Z0-9_]*)(\s*)(?=::[^<]) 1:module

    add-highlighter shared/rhai/code/constant     regex \b([A-Z_][A-Z_]+)\b 1:value

    add-highlighter shared/rhai/code/function     regex \b([a-z_][a-zA-Z_0-9]*)\s*(?=\() 1:function
    add-highlighter shared/rhai/code/function_def regex \b(fn\s+)([a-z_][a-zA-Z_0-9]*) 2:function

    add-highlighter shared/rhai/code/identifier   regex \bthis\b 0:identifier

    add-highlighter shared/rhai/code/keyword      regex \b(?<!r#)(let|const|if|else|switch|do|while|until|loop|for|in|continue|break|return|throw|try|catch|import|export|as|global|private|fn)\b 1:keyword
    add-highlighter shared/rhai/code/reserved     regex \b(?<!r#)(var|static|shared|goto|exit|match|case|public|protected|new|use|with|is|module|package|super|thread|spawn|go|await|async|sync|yield|default|void|null|nil)\b 1:keyword

    # Commands
    # ‾‾‾‾‾‾‾‾

    define-command -hidden rhai-trim-indent %{
        # remove trailing white spaces
        try %{ execute-keys -draft -itersel x s \h+$ <ret> d }
    }

    define-command -hidden rhai-indent-on-new-line %~
        evaluate-commands -draft -itersel %<
            # copy // comments prefix and following white spaces
            try %{ execute-keys -draft k x s ^\h*\K//[!/]?\h* <ret> y gh j P }
            # preserve previous line indent
            try %{ execute-keys -draft <semicolon> K <a-&> }

            # filter previous line
            try %{ execute-keys -draft k : rhai-trim-indent <ret> }
            # indent after lines ending with { or (
            try %[ execute-keys -draft k x <a-k> [{(]\h*$ <ret> j <a-gt> ]
            # indent after lines ending with [{(].+
            # try %< execute-keys -draft [c[({],[)}] <ret> <a-k> L i<ret><esc> <gt> <a-S> <a-&> >
        >
    ~

    define-command -hidden rhai-indent-on-opening-curly-brace %[
        evaluate-commands -draft -itersel %_
            # align indent with opening paren when { is entered on a new line after the closing paren
            try %[ execute-keys -draft h <a-F> ) M <a-k> \A\(.*\)\h*\n\h*\{\z <ret> s \A|.\z <ret> 1<a-&> ]
        _
    ]

    define-command -hidden rhai-indent-on-closing %[
        evaluate-commands -draft -itersel %_
            # align to opening curly brace or paren when alone on a line
            try %< execute-keys -draft <a-h> <a-k> ^\h*[)}]$ <ret> h m <a-S> 1<a-&> >
        _
    ]
§
