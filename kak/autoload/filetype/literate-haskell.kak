# http://haskell.org
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](lhs) %{
    set-option buffer filetype literate-haskell
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=literate-haskell %{
    require-module literate-haskell
    require-module haskell

    set-option buffer extra_word_chars '_' "'"
    # using the regular haskell commands, as they will be the same
    hook window ModeChange pop:insert:.* -group literate-haskell-trim-indent  literate-haskell-trim-indent
    hook window InsertChar \n -group literate-haskell-indent literate-haskell-indent-on-new-line

    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window literate-haskell-.+
        unmap window insert <tab>
        unmap window insert <s-tab>
    }

    map window insert <tab> '<a-;>: literate-haskell-smart-indent<ret>'
    map window insert <s-tab> '<a-;>: literate-haskell-smart-unindent<ret>'
}

hook -group literate-haskell-highlight global WinSetOption filetype=literate-haskell %{
    add-highlighter window/literate-haskell ref literate-haskell
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/literate-haskell }
}


provide-module literate-haskell %[
    # Highlighters
    # ‾‾‾‾‾‾‾‾‾‾‾‾
    add-highlighter shared/literate-haskell regions
    add-highlighter shared/literate-haskell/text default-region group
    add-highlighter shared/literate-haskell/text/    fill doc_comment
    add-highlighter shared/literate-haskell/bird     region "^>" "^[^>]"                           ref bird-haskell
    add-highlighter shared/literate-haskell/tex      region "\\begin\{code\}" "\\end\{code\}"      ref tex-haskell

    add-highlighter shared/tex-haskell group
    add-highlighter shared/tex-haskell/ ref haskell
    add-highlighter shared/tex-haskell/ regex "\\(begin|end)\{code\}"  0:meta

    add-highlighter shared/bird-haskell regions
    add-highlighter shared/bird-haskell/code default-region group
    add-highlighter shared/bird-haskell/string       region (?<!'\\)(?<!')"                 (?<!\\)(\\\\)*"  fill string
    add-highlighter shared/bird-haskell/macro        region ^>\h*?\K#                        (?<!\\)\n       fill meta
    add-highlighter shared/bird-haskell/pragma       region -recurse \{- \{-#               '#-\}'           fill meta
    add-highlighter shared/bird-haskell/comment      region -recurse \{- \{-                  -\}            ref comment
    add-highlighter shared/bird-haskell/line_comment region --(?:[^!#$%&*+./<>?@\\\^|~=]|$) $                ref comment

    add-highlighter shared/bird-haskell/code/ regex (?<!')\b0x+[A-Fa-f0-9]+ 0:value
    add-highlighter shared/bird-haskell/code/ regex (?<!')\b\d+([.]\d+)? 0:value

    add-highlighter shared/bird-haskell/code/ regex (?<!')\b(import|hiding|qualified|module)(?!')\b 0:keyword
    add-highlighter shared/bird-haskell/code/ regex (?<!')\b(import)(?!')\b[^\n]+(?<!')\b(as)(?!')\b 2:keyword
    add-highlighter shared/bird-haskell/code/ regex (?<!')\b(class|data|default|deriving|infix|infixl|infixr|instance|module|newtype|pattern|type|where)(?!')\b 0:keyword
    add-highlighter shared/bird-haskell/code/ regex (?<!')\b(case|do|else|if|in|let|mdo|of|proc|rec|then)(?!')\b 0:keyword

    # The complications below is because period has many uses:
    # As function composition operator (possibly without spaces) like "." and "f.g"
    # Hierarchical modules like "Data.Maybe"
    # Qualified imports like "Data.Maybe.Just", "Data.Maybe.maybe", "Control.Applicative.<$>"
    # Quantifier separator in "forall a . [a] -> [a]"
    # Enum comprehensions like "[1..]" and "[a..b]" (making ".." and "Module..." illegal)


    # matches uppercase identifiers:  Monad Control.Monad
    # not non-space separated dot:    Just.const
    add-highlighter shared/bird-haskell/code/ regex \b([A-Z]['\w]*\.)*[A-Z]['\w]*(?!['\w])(?![.a-z]) 0:type

    # matches infix identifier: `mod` `Apa._T'M`
    add-highlighter shared/bird-haskell/code/ regex `\b([A-Z]['\w]*\.)*[\w]['\w]*` 0:operator
    # matches imported identifiers: 
    add-highlighter shared/bird-haskell/code/ regex \b(([A-Z]['\w]*\.)+)([a-z]['\w]*)+ 1:module 3:function
    # matches imported module
    add-highlighter shared/bird-haskell/code/ regex \bimport\h+([A-Z]['\w]*(\.[A-Z]['\w]*)*) 1:module
    # matches declared module
    add-highlighter shared/bird-haskell/code/ regex \bmodule\h+([A-Z]['\w]*(\.[A-Z]['\w]*)*) 1:module
    # matches imported operators: M.! M.. Control.Monad.>>
    # not operator keywords:      M... M.->
    add-highlighter shared/bird-haskell/code/ regex \b(([A-Z]['\w]*\.)*)([~<=>|:!?/.@$*&#%+\^\-\\])+ 1:module 3:operator
    # matches dot: .
    # not possibly incomplete import:  a.
    # not other operators:             !. .!
    add-highlighter shared/bird-haskell/code/ regex (?<![\w~<=>|:!?/.@$*&#%+\^\-\\])\.(?![~<=>|:!?/.@$*&#%+\^\-\\]) 0:operator
    # matches other operators: ... > < <= ^ <*> <$> etc
    # not dot: .
    # not operator keywords:  @ .. -> :: ~
    add-highlighter shared/bird-haskell/code/ regex (?<![~<=>|:!?/.@$*&#%+\^\-\\])[~<=>|:!?/.@$*&#%+\^\-\\]+ 0:operator

    # matches operator keywords: @ ->
    add-highlighter shared/bird-haskell/code/ regex (?<![~<=>|:!?/.@$*&#%+\^\-\\])(@|~|<-|->|=>|::|=|:|[|])(?![~<=>|:!?/.@$*&#%+\^\-\\]) 1:keyword
    # matches: forall [..variables..] .
    # not the variables
    add-highlighter shared/bird-haskell/code/ regex \b(forall)\b[^.\n]*?(\.) 1:keyword 2:keyword

    # matches 'x' '\\' '\'' '\n' '\0'
    # not incomplete literals: '\'
    # not valid identifiers:   w' _'
    add-highlighter shared/bird-haskell/code/ regex \B'([^\\]|[\\]['"\w\d\\])' 0:value
    # this has to come after operators so '-' etc is correct

    # matches function names in type signatures
    add-highlighter shared/bird-haskell/code/ regex ^>\h*(?:(?:where|let|default)\h+)?([_a-z]['\w]*)\s+::\s 1:function

    # matches quasiquotes
    add-highlighter shared/bird-haskell/quasiquote region \[\b[\w]['\w]*\| \|\] fill string

    # matches the bird marker
    add-highlighter shared/bird-haskell/code/ regex ^> 0:comment

    define-command -hidden literate-haskell-trim-indent %{
        # remove trailing white spaces
        try %{ execute-keys -draft -itersel <a-x> s \h+$ <ret> d }
    }

    define-command -hidden literate-haskell-indent-on-new-line %{
        evaluate-commands -draft -itersel %{
            # copy -- comments and > bird prefix and following white spaces
            try %{ execute-keys -draft k <a-x> s ^>\h*(--\h*)? <ret> y gh j P }
            # indent after lines beginning with condition or ending with expression or =(
            # TODO: support indenting with bird markers, and use that here
            # try %{ execute-keys -draft <semicolon> k x <a-k> ^>?\h*(if)|(case\h+[\w']+\h+of|do|let|where|[=(])$ <ret> j <a-gt> }
        }
    }

    define-command -hidden literate-haskell-smart-indent %{
        try %{ # try and indent as if on normal text
            execute-keys -draft Gh <a-k> \A\h+\z <ret> <a-gt>
            execute-keys <esc>gh<a-i><space>li
        } catch %{
            try %{ # then try to indent as if bird text
                execute-keys -draft Gh <a-k> \A>\h*\z <ret> li <space><space><space><space>
                execute-keys <esc>ghl<a-i><space>li
            } catch %{ # default to the insert spaces tactic
                # TODO: this could be smarter and indent to the next tab stop instead of just inserting 4 chars
                execute-keys <space><space><space><space>
            }
        }
    }

    define-command -hidden literate-haskell-smart-unindent %{
        try %{ # try and indent as if on normal text
            execute-keys -draft ghLLLL <a-k> \A>\h{4}\z <ret> <semicolon>HHHd
        } catch %{
            execute-keys -draft <a-lt>
        }
    }
]
