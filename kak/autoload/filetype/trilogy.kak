# https://github.com/foxfriends/trilogy
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
#
# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](tri) %{
    set-option buffer filetype trilogy
    set buffer tabstop 2
    set buffer indentwidth 2
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=trilogy %[
    require-module trilogy
    hook window ModeChange pop:insert:.* -group trilogy-trim-indent trilogy-trim-indent
    hook window InsertChar \n -group trilogy-indent trilogy-indent-on-new-line
    hook window InsertChar \{ -group trilogy-indent trilogy-indent-on-opening-curly-brace
    hook window InsertChar [)}] -group trilogy-indent trilogy-indent-on-closing
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window trilogy-.+ }
]

hook -group trilogy-highlight global WinSetOption filetype=trilogy %{
    add-highlighter window/trilogy ref trilogy
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/trilogy }
}

provide-module trilogy %§
    # Highlighters
    # ‾‾‾‾‾‾‾‾‾‾‾‾
    add-highlighter shared/trilogy regions
    add-highlighter shared/trilogy/code default-region group

    add-highlighter shared/trilogy/    region -recurse "#-" "#-" "-#"     ref comment
    add-highlighter shared/trilogy/    region "#[#!]" "$"                 ref doc_comment
    add-highlighter shared/trilogy/    region %{(?<!['"])#} "$"                     ref comment

    add-highlighter shared/trilogy/template    region %{(?<!')"} (?<!\\)(\\\\)*"       regions
    add-highlighter shared/trilogy/template/string   default-region group
    add-highlighter shared/trilogy/template/string/  fill string

    add-highlighter shared/trilogy/template/interpolation  region -recurse \{ \$\{   \}  regions
    add-highlighter shared/trilogy/template/interpolation/  default-region fill interpolation
    add-highlighter shared/trilogy/template/interpolation/  region -recurse \{ \$\{\K   (?=\})  ref trilogy

    add-highlighter shared/trilogy/code/    regex (\[|\]|\[\||\|\]|\{\||\|\})    1:operator
    add-highlighter shared/trilogy/code/    regex (=|==|===|!=|!==|<|>|<=|>=|=>) 1:operator
    add-highlighter shared/trilogy/code/    regex (->|<-) 1:operator
    add-highlighter shared/trilogy/code/    regex (~|~>|<~|<~=|~>=|\||&|\^|&=|\|=|\^=) 1:operator
    add-highlighter shared/trilogy/code/    regex (\|\||&&|!) 1:operator
    add-highlighter shared/trilogy/code/    regex (<<|>>|<<=|>>=|\|>|<\|) 1:operator
    add-highlighter shared/trilogy/code/    regex (<>|<>=|:|:=) 1:operator
    add-highlighter shared/trilogy/code/    regex (::|\.|\.=) 1:operator
    add-highlighter shared/trilogy/code/    regex (\+=|-=|\*=|\*\*=|/=|//=|%=|\+|-|/|//|\*|\*\*|%) 1:operator


    add-highlighter shared/trilogy/code/    regex \b(([0-9][0-9_]*(\.[0-9_]*)?)|(0x[0-9A-Fa-f_]+)|(0o[0-7_]+)|(0b[01_]+))i?\b 0:value

    add-highlighter shared/trilogy/code/    regex \b(0bx[0-9A-Fa-f_]*)\b 1:value
    add-highlighter shared/trilogy/code/    regex \b(0bo[0-7_]*)\b 1:value
    add-highlighter shared/trilogy/code/    regex \b(0bb[01_]*)\b 1:value

    add-highlighter shared/trilogy/code/    regex \b(true|false)\b 1:value
    add-highlighter shared/trilogy/code/    regex \b(unit)\b 1:value
    add-highlighter shared/trilogy/code/    regex \b([a-z_][a-zA-Z_0-9]*!?)*(?=\() 1:function
    add-highlighter shared/trilogy/code/    regex \bfunc\b\s([a-z_][a-zA-Z_0-9]*) 1:function

    add-highlighter shared/trilogy/code/    regex \b(and|assert|as|become|break|cancel||continue|case|defer|do|else|end|exit|export|extern|fn|for|func|if|import|in|is|let|match|mut|not|or|pass|proc|qy|resume|return|rule|slot|super|test|then|type|typeof|use|using|when|while|with|yield)\b 1:keyword
    add-highlighter shared/trilogy/code/    regex \b(async|await|catch|class|const|data|enum|except|extends|implements|inline|instanceof|interface|iter|lazy|lens|loop|macro|module|next|oper|prec|protocol|static|struct|switch|tag|trait|try|unless|until|where)\b 1:error
    add-highlighter shared/trilogy/code/    regex ('[A-Za-z_][A-Za-z_0-9]*)[^'] 1:type
    add-highlighter shared/trilogy/code/    regex ('([^'\\]|\\'|\\"|\\\\|\\n|\\r|\\t|\\0|\\x[0-9A-F]{2}|\\u\{[0-9a-fA-F]{1,6}\})') 1:value
    add-highlighter shared/trilogy/code/    regex ('[A-Za-z_][A-Za-z_0-9]+') 1:error

    # Commands
    # ‾‾‾‾‾‾‾‾

    define-command -hidden trilogy-trim-indent %{
        # remove trailing white spaces
        try %{ execute-keys -draft -itersel x s \h+$ <ret> d }
    }

    define-command -hidden trilogy-indent-on-new-line %~
        evaluate-commands -draft -itersel %<
            # copy #[#!] comments prefix and following white spaces
            try %{ execute-keys -draft k x s ^\h*\K#[!#]?\h* <ret> y gh j P }
            # preserve previous line indent
            try %{ execute-keys -draft <semicolon> K <a-&> }

            # filter previous line
            try %{ execute-keys -draft k : trilogy-trim-indent <ret> }
            # indent after lines ending with { or (
            try %[ execute-keys -draft k x <a-k> [{(]\h*$ <ret> j <a-gt> ]
            # indent after lines ending with [{(].+
            # try %< execute-keys -draft [c[({],[)}] <ret> <a-k> L i<ret><esc> <gt> <a-S> <a-&> >
        >
    ~

    define-command -hidden trilogy-indent-on-opening-curly-brace %[
        evaluate-commands -draft -itersel %_
            # align indent with opening paren when { is entered on a new line after the closing paren
            try %[ execute-keys -draft h <a-F> ) M <a-k> \A\(.*\)\h*\n\h*\{\z <ret> s \A|.\z <ret> 1<a-&> ]
        _
    ]

    define-command -hidden trilogy-indent-on-closing %[
        evaluate-commands -draft -itersel %_
            # align to opening curly brace or paren when alone on a line
            try %< execute-keys -draft <a-h> <a-k> ^\h*[)}]$ <ret> h m <a-S> 1<a-&> >
        _
    ]
§
