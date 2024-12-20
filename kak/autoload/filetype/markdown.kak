# http://daringfireball.net/projects/markdown
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](markdown|md|mkd) %{
    set-option buffer filetype markdown
}

hook global BufCreate .*[.](svx) %{
    set-option buffer filetype markdown
    set buffer tabstop 2
    set buffer indentwidth 2
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=markdown %{
    require-module markdown
    require-module yaml

    hook window InsertChar \n -group markdown-indent markdown-indent-on-new-line
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window markdown-.+ }
}

hook -group markdown-load-languages global WinSetOption filetype=markdown %{
    hook -group markdown-load-languages window NormalIdle .* markdown-load-languages
    hook -group markdown-load-languages window InsertIdle .* markdown-load-languages
}


hook -group markdown-highlight global WinSetOption filetype=markdown %{
    add-highlighter window/markdown ref markdown
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/markdown }
}


provide-module markdown %{
    try %{
        require-module html
    }

    # Highlighters
    # ‾‾‾‾‾‾‾‾‾‾‾‾

    add-highlighter shared/markdown regions
    add-highlighter shared/markdown/comment region "<!--" "-->" ref comment
    add-highlighter shared/markdown/inline default-region regions
    add-highlighter shared/markdown/inline/text default-region group

    evaluate-commands %sh{
      languages="
        awk c cabal clojure coffee cpp css cucumber d diff dockerfile fish
        gas go haml haskell html ini java javascript json julia kak kickstart
        kotlin latex lisp lua makefile markdown moon objc perl pug python ragel
        ruby rust sass scala scss sh swift toml tupfile typescript yaml sql
        sml scheme graphql
      "
      for lang in ${languages}; do
        printf 'add-highlighter shared/markdown/%s region -match-capture ^(\\h*)```\\h*%s\\b   ^(\\h*)``` regions\n' "${lang}" "${lang}"
        printf 'add-highlighter shared/markdown/%s/ default-region fill meta\n' "${lang}"
        [ "${lang}" = kak ] && ref=kakrc || ref="${lang}" # seems like kakrc file should be kak even though it's not .kak
        printf 'add-highlighter shared/markdown/%s/inner region ^\\h*```[^\\n]*\\K (?=```) ref %s\n' "${lang}" "${ref}"
      done
    }

    add-highlighter shared/markdown/codeblock region -match-capture \
        ^(\h*)```\h* \
        ^(\h*)```\h*$ \
        fill meta

    add-highlighter shared/markdown/frontmatter region -match-capture \
        ^---\h*$ \
        ^---\h*$ \
        ref yaml

    add-highlighter shared/markdown/listblock region ^\h*[-*]\s ^\h*((?=[-*])|$) regions
    add-highlighter shared/markdown/listblock/marker region \A [-*]\s fill bullet
    add-highlighter shared/markdown/listblock/content default-region ref markdown/inline

    add-highlighter shared/markdown/inline/code region -match-capture (`) (`) fill mono

    # Setext-style header
    add-highlighter shared/markdown/inline/text/ regex (\A|\n\n)[^\n]+\n={2,}\h*\n\h*$ 0:title
    add-highlighter shared/markdown/inline/text/ regex (\A|\n\n)[^\n]+\n-{2,}\h*\n\h*$ 0:header

    # Atx-style header
    add-highlighter shared/markdown/inline/text/ regex "^#{1,6}(\n| [^\n]*)" 0:header

    add-highlighter shared/markdown/inline/text/ regex (?<!\*)(\*([^\s*]|([^\s*](\n?[^\n*])*[^\s*]))\*)(?!\*) 1:italic
    add-highlighter shared/markdown/inline/text/ regex (?<!_)(_([^\s_]|([^\s_](\n?[^\n_])*[^\s_]))_)(?!_) 1:italic
    add-highlighter shared/markdown/inline/text/ regex (?<!\*)(\*\*([^\s*]|([^\s*](\n?[^\n*])*[^\s*]))\*\*)(?!\*) 1:bold
    add-highlighter shared/markdown/inline/text/ regex (?<!_)(__([^\s_]|([^\s_](\n?[^\n_])*[^\s_]))__)(?!_) 1:bold
    add-highlighter shared/markdown/inline/text/ regex <(([a-z]+://.*?)|((mailto:)?[\w+-]+@[a-z]+[.][a-z]+))> 0:link
    add-highlighter shared/markdown/inline/text/ regex ^\[[^\]\n]*\]:\h*([^\n]*) 1:link
    add-highlighter shared/markdown/inline/text/ regex ^\h*(>\h*)+ 0:comment
    add-highlighter shared/markdown/inline/text/ regex \H\K\h\h$ 0:PrimarySelection
    add-highlighter shared/markdown/inline/text/ ref html

    # Commands
    # ‾‾‾‾‾‾‾‾

    define-command -hidden markdown-indent-on-new-line %{
        evaluate-commands -draft -itersel %{
            # copy block quote(s), list item prefix and following white spaces
            try %{ execute-keys -draft kxs^\h*\K((>\h*)+([*+-]\h)?|(>\h*)*[*+-]\h)\h*<ret>yghjP }
            # preserve previous line indent
            try %{ execute-keys -draft <semicolon>K<a-&> }
            # remove trailing white spaces
            try %{ execute-keys -draft -itersel %{kxs\h+$<ret>d} }
        }
    }

    define-command -hidden markdown-load-languages %{
        evaluate-commands -draft %{ try %{
            execute-keys 'gtGbGls```\h*\K[^\s]+<ret>'
            evaluate-commands -itersel %{ require-module %val{selection} }
        }}
    }
}
