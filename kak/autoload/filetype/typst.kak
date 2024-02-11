# https://typst.app
#
# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*\.(typ) %{
    set-option buffer filetype typst
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=typst %~
    require-module typst

    hook window InsertChar \n -group typst-indent typst-indent-on-new-line
    hook window InsertChar [)] -group typst-indent typst-indent-on-closing
    hook window ModeChange pop:insert:.* -group typst-indent typst-trim-indent
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks typst-indent }
~

hook -group typst-load-languages global WinSetOption filetype=typst %{
    hook -group typst-load-languages window NormalIdle .* typst-load-languages
    hook -group typst-load-languages window InsertIdle .* typst-load-languages
}

hook -group typst-highlight global WinSetOption filetype=typst %{
    add-highlighter window/typst ref typst
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/typst }
}

# hook global BufSetOption filetype=typst %{
#     set-option buffer buildcmd "typst compile %val{buffile}"
# }

provide-module typst %§
    # Highlighters
    # ‾‾‾‾‾‾‾‾‾‾‾‾

    add-highlighter shared/typst regions

    evaluate-commands %sh{
      languages="
        awk c cabal clojure coffee cpp css cucumber d diff dockerfile fish
        gas go haml haskell html ini java javascript json julia kak kickstart
        latex lisp lua makefile typst moon objc perl pug python ragel
        ruby rust sass scala scss sh swift toml tupfile typescript yaml sql
        sml scheme graphql
      "
      for lang in ${languages}; do
        printf 'add-highlighter shared/typst/%s region -match-capture ```%s\\b   ``` regions\n' "${lang}" "${lang}"
        printf 'add-highlighter shared/typst/%s/ default-region fill meta\n' "${lang}"
        [ "${lang}" = kak ] && ref=kakrc || ref="${lang}" # seems like kakrc file should be kak even though it's not .kak
        printf 'add-highlighter shared/typst/%s/inner region ```%s\\b\\K (?=```) ref %s\n' "${lang}" "${lang}" "${ref}"
      done
    }

    add-highlighter shared/typst/comment          region -recurse "/\*" "/\*" "\*/"              ref comment
    add-highlighter shared/typst/line_comment     region "//" "$"                                ref comment
    add-highlighter shared/typst/rawblock region ``` ``` fill string
    add-highlighter shared/typst/raw region ` ` fill string

    add-highlighter shared/typst/math region \$ \$ regions
    add-highlighter shared/typst/math/ default-region fill operator
    add-highlighter shared/typst/math/inner region \$\K (?=\$) group
    add-highlighter shared/typst/math/inner/ fill value
    add-highlighter shared/typst/math/inner/ regex (\b[a-z_][a-zA-Z0-9_]*)\b(?:\s*\() 1:function
    add-highlighter shared/typst/math/inner/ regex (&|/|_|\^) 1:operator
    add-highlighter shared/typst/math/inner/ regex \\. 0:meta
    add-highlighter shared/typst/math/inner/ regex (#)\w+\b 0:variable

    add-highlighter shared/typst/text default-region group
    add-highlighter shared/typst/text/ regex ^\s*([-+/])\s 1:bullet
    add-highlighter shared/typst/text/ regex (?S)^(=+)\s+(.*)$ 1:operator 2:title
    add-highlighter shared/typst/text/ regex <\w+> 0:meta
    add-highlighter shared/typst/text/ regex @(\w+)\b 0:meta
    add-highlighter shared/typst/text/ regex \\. 0:meta
    add-highlighter shared/typst/text/ regex (#[a-z_][a-zA-Z0-9_]*)\b(?:\s*\() 1:function

    add-highlighter shared/typst/text/ regex (?<!_)(_([^\s_]|([^\s_](\n?[^\n_])*[^\s_]))_)(?!_) 1:italic
    add-highlighter shared/typst/text/ regex (?<!\*)(\*([^\s\*]|([^\s\*](\n?[^\n\*])*[^\s\*]))\*)(?!\*) 1:bold
    add-highlighter shared/typst/text/ regex (https?://.*?) 0:link

    # Commands
    # ‾‾‾‾‾‾‾‾

    define-command -hidden typst-load-languages %{
        evaluate-commands -draft %{ try %{
            execute-keys 'gtGbGls```\h*\K[^\s]+<ret>'
            evaluate-commands -itersel %{ require-module %val{selection} }
        }}
    }

    define-command -hidden typst-trim-indent %{
        evaluate-commands -no-hooks -draft -itersel %{
            try %{ execute-keys x 1s^(\h+)$<ret> d }
        }
    }

    define-command -hidden typst-indent-on-new-line %~
        evaluate-commands -draft -itersel %<
            # copy // comments prefix and following white spaces
            try %{ execute-keys -draft k x s ^\h*\K//\h* <ret> y gh j P }
            # preserve previous line indent
            try %{ execute-keys -draft <semicolon> K <a-&> }

            # filter previous line
            try %{ execute-keys -draft k : typst-trim-indent <ret> }
            # indent after lines ending with (
            try %[ execute-keys -draft k x <a-k> [(]\h*$ <ret> j <a-gt> ]
        >
    ~

    define-command -hidden typst-indent-on-closing %[
        evaluate-commands -draft -itersel %_
            # align to opening curly brace or paren when alone on a line
            try %< execute-keys -draft <a-h> <a-k> ^\h*[)]$ <ret> h m <a-S> 1<a-&> >
        _
    ]
§
