# http://rust-lang.org
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
#
# This plugin is a replacement for the built in rc/filetype/rust.kak with improve syntax highlighting.

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](rust|rs) %{
    set-option buffer filetype rust
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=rust %[
    require-module rust

    try {
        require-module detection
        check-cmd rustfmt
        set-option buffer formatcmd 'rustfmt'
    }

    try {
        require-module detection
        check-cmd clippy-driver
        set-option buffer lintcmd 'cargo clippy'
        lint-enable
    }

    hook window ModeChange pop:insert:.* -group rust-trim-indent rust-trim-indent
    hook window InsertChar \n -group rust-indent rust-indent-on-new-line
    hook window InsertChar \{ -group rust-indent rust-indent-on-opening-curly-brace
    hook window InsertChar [)}] -group rust-indent rust-indent-on-closing
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window rust-.+ }
]

hook -group rust-highlight global WinSetOption filetype=rust %{
    add-highlighter window/rust ref rust
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/rust }
}

provide-module rust %§
    # Highlighters
    # ‾‾‾‾‾‾‾‾‾‾‾‾
    add-highlighter shared/rust regions
    add-highlighter shared/rust/code default-region group

    add-highlighter shared/rust/string           region %{(?<!')"} (?<!\\)(\\\\)*"              fill string
    add-highlighter shared/rust/raw_string       region -match-capture %{(?<!')r(#*)"} %{"(#*)} fill string
    add-highlighter shared/rust/comment          region -recurse "/\*" "/\*" "\*/"              ref comment
    add-highlighter shared/rust/doc_comment      region "//[/!]" "$"                            ref doc_comment
    add-highlighter shared/rust/line_comment     region "//" "$"                                ref comment
    add-highlighter shared/rust/attribute        region "#!?\[" "\]"                            fill meta

    add-highlighter shared/rust/code/operator     regex (\[|\]|=|==|!=|\+=|-=|\*=|/=|%=|<|>|<=|>=|=>|->|\+|-|/|\*|%|~|\||\|\||&|&&|!|\^|\?|<<|>>|<<=|>>=|\.|\.\.|\.\.=) 1:operator
    add-highlighter shared/rust/code/scope        regex (:) 1:default+fd

    add-highlighter shared/rust/code/zero         regex \b(0([ui](8|16|32|64|128|size)|f(32|64|size))?)\b 1:value
    add-highlighter shared/rust/code/decimal-int  regex \b([1-9][0-9_]*([ui](8|16|32|64|128|size))?)\b 1:value
    add-highlighter shared/rust/code/float        regex \b([1-9][0-9_]*(\.[0-9_]*)?(e[+-]?[1-9][0-9_]*)?(f(32|64|size))?)\b 1:value
    add-highlighter shared/rust/code/hex-int      regex \b(0x[0-9A-Fa-f_]+([ui](8|16|32|64|128|size))?)\b 1:value
    add-highlighter shared/rust/code/octal-int    regex \b(0o[0-7_]+([ui](8|16|32|64|128|size))?)\b 1:value
    add-highlighter shared/rust/code/binary-int   regex \b(0b[01_]+)([ui](8|16|32|64|128|size))?\b 1:value
    add-highlighter shared/rust/code/character    regex ('([^'\\]|\\'|\\\\|\\u\{[0-9a-fA-F]{1,4}\})') 1:value
    add-highlighter shared/rust/code/bool         regex \b(true|false)\b 1:value

    add-highlighter shared/rust/code/module       regex (?:pub\s+)?mod\s+((r#)?[a-zA-Z_][a-zA-Z0-9_]*) 1:module
    add-highlighter shared/rust/code/namespace    regex \b((r#)?[a-z][a-zA-Z0-9_]*)(\s*)(?=::[^<]) 1:module

    add-highlighter shared/rust/code/type         regex \b((r#)?[A-Z][a-zA-Z0-9_]*)\b 1:type
    add-highlighter shared/rust/code/constant     regex \b((r#)?[A-Z_][A-Z_]+)\b 1:value

    add-highlighter shared/rust/code/function     regex \b((r#)?[a-z_][a-zA-Z_0-9]*)\s*(?=\() 1:function
    add-highlighter shared/rust/code/function_def regex \b(fn\s+)((r#)?[a-z_][a-zA-Z_0-9]*) 2:function
    add-highlighter shared/rust/code/turbo_fish   regex \b((r#)?[a-z_][a-zA-Z_0-9]*)(?=::<) 1:function

    add-highlighter shared/rust/code/macro        regex \b((r#)?[a-z_][a-zA-Z_0-9]*!)\s*(?=[\[{(]) 1:meta
    add-highlighter shared/rust/code/macro_rules  regex \b(macro_rules!)\s+([a-zA-Z_][a-zA-Z0-9_]*) 1:meta 2:meta
    add-highlighter shared/rust/code/lifetime     regex ('[A-Za-z_][A-Za-z_0-9]*)[^'] 1:meta
    add-highlighter shared/rust/code/primitive    regex \b(i8|i16|i32|i64|i128|isize|u8|u16|u32|u64|u128|usize|f32|f64|fsize|str|char|bool)\b 1:keyword
    add-highlighter shared/rust/code/identifier   regex \bself\b 0:identifier

    add-highlighter shared/rust/code/keyword      regex \b(?<!r#)(use|mod|struct|enum|union|type|yield|await|async|(?:async\s+)?fn|trait|impl|return|if|match|where|in|as|else|for|while|loop|const|static|let|mut|ref|dyn|box|pub|crate|super|extern|move|break|continue)\b 1:keyword
    add-highlighter shared/rust/code/unsafe       regex \bunsafe\b 0:field

    # Commands
    # ‾‾‾‾‾‾‾‾

    define-command -hidden rust-trim-indent %{
        # remove trailing white spaces
        try %{ execute-keys -draft -itersel <a-x> s \h+$ <ret> d }
    }

    define-command -hidden rust-indent-on-new-line %~
        evaluate-commands -draft -itersel %<
            # copy // comments prefix and following white spaces
            try %{ execute-keys -draft k <a-x> s ^\h*\K//[!/]?\h* <ret> y gh j P }
            # preserve previous line indent
            try %{ execute-keys -draft <semicolon> K <a-&> }
            
            # filter previous line
            try %{ execute-keys -draft k : rust-trim-indent <ret> }
            # indent after lines ending with { or (
            try %[ execute-keys -draft k <a-x> <a-k> [{(]\h*$ <ret> j <a-gt> ]
            # indent after lines ending with [{(].+
            # try %< execute-keys -draft [c[({],[)}] <ret> <a-k> L i<ret><esc> <gt> <a-S> <a-&> >
        >
    ~

    define-command -hidden rust-indent-on-opening-curly-brace %[
        evaluate-commands -draft -itersel %_
            # align indent with opening paren when { is entered on a new line after the closing paren
            try %[ execute-keys -draft h <a-F> ) M <a-k> \A\(.*\)\h*\n\h*\{\z <ret> s \A|.\z <ret> 1<a-&> ]
        _
    ]

    define-command -hidden rust-indent-on-closing %[
        evaluate-commands -draft -itersel %_
            # align to opening curly brace or paren when alone on a line
            try %< execute-keys -draft <a-h> <a-k> ^\h*[)}]$ <ret> h m <a-S> 1<a-&> >
        _
    ]
§
