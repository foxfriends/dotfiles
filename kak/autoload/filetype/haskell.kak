# http://haskell.org
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](hs) %{
    set-option buffer filetype haskell
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=haskell %{
    require-module haskell

    set-option buffer extra_word_chars '_' "'"
    hook window ModeChange pop:insert:.* -group haskell-trim-indent  haskell-trim-indent
    hook window InsertChar \n -group haskell-indent haskell-indent-on-new-line
    set buffer tabstop 2
    set buffer indentwidth 2

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window haskell-.+ }

    try %{
        require-module detection
        check-cmd ormolu
        set-option buffer formatcmd 'ormolu --stdin-input-file %val{buffile}'
    }
    try %{
        require-module detection
        check-cmd hlint
        set-option window lintcmd "hlint %val{buffile}"
    }
}

hook -group haskell-highlight global WinSetOption filetype=haskell %{
    add-highlighter window/haskell ref haskell
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/haskell }
}


provide-module haskell %[
    # Highlighters
    # ‾‾‾‾‾‾‾‾‾‾‾‾

    add-highlighter shared/haskell regions
    add-highlighter shared/haskell/code default-region group
    add-highlighter shared/haskell/string       region (?<!'\\)(?<!')"                 (?<!\\)(\\\\)*"  fill string
    add-highlighter shared/haskell/macro        region ^\h*?\K#                        (?<!\\)\n        fill meta
    add-highlighter shared/haskell/pragma       region -recurse \{- \{-#               '#-\}'           fill meta
    add-highlighter shared/haskell/comment      region -recurse \{- \{-                  -\}            ref comment
    add-highlighter shared/haskell/line_comment region --(?:[^!#$%&*+./<>?@\\\^|~=]|$) $                ref comment

    add-highlighter shared/haskell/code/ regex (?<!')\b0x+[A-Fa-f0-9]+ 0:value
    add-highlighter shared/haskell/code/ regex (?<!')\b0b+[10]+ 0:value
    add-highlighter shared/haskell/code/ regex (?<!')\b0o+[0-7]+ 0:value
    add-highlighter shared/haskell/code/ regex (?<!')\b\d+([.]\d+)? 0:value

    add-highlighter shared/haskell/code/ regex (?<!')\b(import|hiding|qualified|module)(?!')\b 0:keyword
    add-highlighter shared/haskell/code/ regex (?<!')\b(import)(?!')\b[^\n]+(?<!')\b(as)(?!')\b 2:keyword
    add-highlighter shared/haskell/code/ regex (?<!')\b(class|data|default|deriving|infix|infixl|infixr|instance|module|newtype|pattern|type|where)(?!')\b 0:keyword
    add-highlighter shared/haskell/code/ regex (?<!')\b(case|do|else|if|in|let|mdo|of|proc|rec|then)(?!')\b 0:keyword

    # The complications below is because period has many uses:
    # As function composition operator (possibly without spaces) like "." and "f.g"
    # Hierarchical modules like "Data.Maybe"
    # Qualified imports like "Data.Maybe.Just", "Data.Maybe.maybe", "Control.Applicative.<$>"
    # Quantifier separator in "forall a . [a] -> [a]"
    # Enum comprehensions like "[1..]" and "[a..b]" (making ".." and "Module..." illegal)


    # matches uppercase identifiers:  Monad Control.Monad
    # not non-space separated dot:    Just.const
    add-highlighter shared/haskell/code/ regex \b([A-Z]['\w]*\.)*[A-Z]['\w]*(?!['\w])(?![.a-z]) 0:type

    # matches infix identifier: `mod` `Apa._T'M`
    add-highlighter shared/haskell/code/ regex `\b([A-Z]['\w]*\.)*[\w]['\w]*` 0:operator
    # matches imported identifiers:
    add-highlighter shared/haskell/code/ regex \b(([A-Z]['\w]*\.)+)([a-z]['\w]*)+ 1:module 3:function
    # matches imported module
    add-highlighter shared/haskell/code/ regex \bimport\h+([A-Z]['\w]*(\.[A-Z]['\w]*)*) 1:module
    # matches declared module
    add-highlighter shared/haskell/code/ regex \bmodule\h+([A-Z]['\w]*(\.[A-Z]['\w]*)*) 1:module
    # matches imported operators: M.! M.. Control.Monad.>>
    # not operator keywords:      M... M.->
    add-highlighter shared/haskell/code/ regex \b(([A-Z]['\w]*\.)*)([~<=>|:!?/.@$*&#%+\^\-\\])+ 1:module 3:operator
    # matches dot: .
    # not possibly incomplete import:  a.
    # not other operators:             !. .!
    add-highlighter shared/haskell/code/ regex (?<![\w~<=>|:!?/.@$*&#%+\^\-\\])\.(?![~<=>|:!?/.@$*&#%+\^\-\\]) 0:operator
    # matches other operators: ... > < <= ^ <*> <$> etc
    # not dot: .
    # not operator keywords:  @ .. -> :: ~
    add-highlighter shared/haskell/code/ regex (?<![~<=>|:!?/.@$*&#%+\^\-\\])[~<=>|:!?/.@$*&#%+\^\-\\]+ 0:operator

    # matches operator keywords: @ ->
    add-highlighter shared/haskell/code/ regex (?<![~<=>|:!?/.@$*&#%+\^\-\\])(@|~|<-|->|=>|::|=|:|[|])(?![~<=>|:!?/.@$*&#%+\^\-\\]) 1:keyword
    # matches: forall [..variables..] .
    # not the variables
    add-highlighter shared/haskell/code/ regex \b(forall)\b[^.\n]*?(\.) 1:keyword 2:keyword

    # matches 'x' '\\' '\'' '\n' '\0'
    # not incomplete literals: '\'
    # not valid identifiers:   w' _'
    add-highlighter shared/haskell/code/ regex \B'([^\\]|[\\]['"\w\d\\])' 0:value
    # this has to come after operators so '-' etc is correct

    # matches function names in type signatures
    add-highlighter shared/haskell/code/ regex ^\h*(?:(?:where|let|default)\h+)?([_a-z]['\w]*)\s+::\s 1:function

    # matches quasiquotes
    add-highlighter shared/haskell/quasiquote region \[\b[\w]['\w]*\| \|\] fill string

    # Commands
    # ‾‾‾‾‾‾‾‾

    # http://en.wikibooks.org/wiki/Haskell/Indentation

    define-command -hidden haskell-trim-indent %{
        # remove trailing white spaces
        try %{ execute-keys -draft -itersel x s \h+$ <ret> d }
    }

    define-command -hidden haskell-indent-on-new-line %{
        evaluate-commands -draft -itersel %{
            # copy -- comments prefix and following white spaces
            try %{ execute-keys -draft k x s ^\h*\K--\h* <ret> y gh j P }
            # preserve previous line indent
            try %{ execute-keys -draft <semicolon> K <a-&> }
            # align to first clause
            try %{ execute-keys -draft <semicolon> k x X s ^\h*(if|then|else)?\h*(([\w']+\h+)+=)?\h*(case\h+[\w']+\h+of|do|let|where)\h+\K.* <ret> s \A|.\z <ret> & }
            # filter previous line
            try %{ execute-keys -draft k : haskell-trim-indent <ret> }
            # indent after lines beginning with condition or ending with expression or =(
            try %{ execute-keys -draft <semicolon> k x <a-k> ^\h*(if)|(case\h+[\w']+\h+of|do|let|where|[=(])$ <ret> j <a-gt> }
        }
    }
]
