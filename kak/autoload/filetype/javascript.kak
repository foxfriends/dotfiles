# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.][cm]?(js)x? %{
    set-option buffer filetype javascript
    set buffer tabstop 2
    set buffer indentwidth 2
    set buffer relatedfilecmd "%val{config}/scripts/js-related-file"
}

hook global BufCreate .*[.](ts)x? %{
    set-option buffer filetype typescript
    set buffer tabstop 2
    set buffer indentwidth 2
}

define-command -hidden js-set-deno %{
    try %{
        check-cmd deno
        find-in-parent deno.json %sh{dirname "$kak_buffile"}
        set buffer formatcmd "%val{config}/scripts/deno-fmt %val{buffile}"
        set buffer lintcmd "%val{config}/scripts/deno-lint"
    } catch %{ echo -debug %val{error} }
}

define-command -hidden js-set-node %{
    try %{
        check-cmd prettier
        set buffer formatcmd "prettier --stdin-filepath '%val{buffile}'"
    } catch %{ echo -debug %val{error} }
    try %{
        check-cmd eslint
        check-file %sh{echo "$(npm root -g)/eslint-formatter-kakoune/index.js"}
        find-in-parent package.json %sh{dirname "$kak_buffile"}
        set buffer lintcmd 'run() { cat "$1" | eslint -f "$(npm root -g)/eslint-formatter-kakoune/index.js" --stdin --stdin-filename "$kak_buffile"; } && run'
    } catch %{ echo -debug %val{error} }
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾
hook global WinSetOption filetype=(javascript|typescript) %{
    require-module %val{hook_param_capture_1}

    try %{ js-set-node }
    try %{ js-set-deno }

    hook window ModeChange pop:insert:.* -group "%val{hook_param_capture_1}-trim-indent" javascript-trim-indent
    hook window InsertChar .* -group "%val{hook_param_capture_1}-indent" javascript-indent-on-char
    hook window InsertChar \n -group "%val{hook_param_capture_1}-indent" javascript-indent-on-new-line

    hook -once -always window WinSetOption filetype=.* "
        remove-hooks window %val{hook_param_capture_1}-.+
    "
}

hook global BufSetOption filetype=(javascript) %{
    require-module detection
    check-cmd node
    set buffer runcmd 'node'
}

hook global BufSetOption filetype=(typescript) %{
    require-module detection
    check-cmd npx
    set buffer runcmd 'npx tsx'
}

hook -group javascript-load-languages global WinSetOption filetype=javascript %{
    hook -group javascript-load-languages window NormalIdle .* javascript-load-languages
    hook -group javascript-load-languages window InsertIdle .* javascript-load-languages
}

hook -group typescript-load-languages global WinSetOption filetype=typescript %{
    hook -group javascript-load-languages window NormalIdle .* javascript-load-languages
    hook -group javascript-load-languages window InsertIdle .* javascript-load-languages
}

hook -group javascript-highlight global WinSetOption filetype=javascript %{
    add-highlighter window/javascript ref javascript
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/javascript }
}

hook -group typescript-highlight global WinSetOption filetype=typescript %{
    add-highlighter window/typescript ref typescript
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/typescript }
}

provide-module javascript_impl %§
    # Commands
    # ‾‾‾‾‾‾‾‾

    define-command -hidden javascript-trim-indent %{
        # remove trailing white spaces
        try %{ execute-keys -draft -itersel x s \h+$ <ret> d }
    }

    define-command -hidden javascript-indent-on-char %<
        evaluate-commands -draft -itersel %<
            # align closer token to its opener when alone on a line
            try %/ execute-keys -draft <a-h> <a-k> ^\h+[\]}]$ <ret> m s \A|.\z <ret> 1<a-&> /
        >
    >

    define-command -hidden javascript-indent-on-new-line %<
        evaluate-commands -draft -itersel %<
            # preserve previous line indent
            try %{ execute-keys -draft <semicolon> K <a-&> }
            # filter previous line
            try %{ execute-keys -draft k : javascript-trim-indent <ret> }
            # indent after lines beginning / ending with opener token
            try %_ execute-keys -draft k x <a-k> ^\h*[[{]|[[{]$ <ret> j <a-gt> _
        >
    >

    # Highlighting and hooks bulder for JavaScript and TypeScript
    # ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
    define-command -hidden init-javascript-filetype -params 1 %~
        # Highlighters
        # ‾‾‾‾‾‾‾‾‾‾‾‾

        add-highlighter "shared/%arg{1}" regions
        add-highlighter "shared/%arg{1}/code" default-region group
        add-highlighter "shared/%arg{1}/comment_line"  region //   '$'                     ref comment
        add-highlighter "shared/%arg{1}/jsdoc_comment" region /\*\*  \*/                   ref jsdoc
        add-highlighter "shared/%arg{1}/comment"       region /\*  \*/                     ref comment
        add-highlighter "shared/%arg{1}/shebang"       region ^#!  $                       fill meta
        add-highlighter "shared/%arg{1}/regex"         region /    ((?<!\\)(\\\\)*/[gimuy]*|$) fill meta
        add-highlighter "shared/%arg{1}/double_string" region '"'  ((?<!\\)(\\\\)*"|((?<!\\)(\\\\)*\n$))     fill string
        add-highlighter "shared/%arg{1}/single_string" region "'"  ((?<!\\)(\\\\)*'|((?<!\\)(\\\\)*\n$))     fill string

        # Literals tagged with a language name are likely to be written in that language
        evaluate-commands %sh{
          languages="
            awk c cabal clojure coffee cpp css cucumber d diff dockerfile fish
            gas go haml haskell html ini java javascript json julia kak kickstart
            latex lisp lua makefile markdown moon objc perl pug python ragel
            ruby rust sass scala scss sh swift toml tupfile typescript yaml sql
            sml scheme graphql
          "
          for lang in ${languages}; do
            printf 'add-highlighter shared/%s/%s region -match-capture \\b%s` (?<!\\\\)(\\\\\\\\)*` regions\n' "$1" "${lang}" "${lang}"
            printf 'add-highlighter shared/%s/%s/ default-region fill string\n' "$1" "${lang}"
            [ "${lang}" = kak ] && ref=kakrc || ref="${lang}" # seems like kakrc file should be kak even though it's not .kak
            printf 'add-highlighter shared/%s/%s/inner region \\b%s`\\K (?<!\\\\)(\\\\\\\\)*(?=`) ref %s\n' "$1" "${lang}" "${lang}" "${ref}"
          done
        }

        add-highlighter "shared/%arg{1}/literal"       region "`"  (?<!\\)(\\\\)*`         regions
        add-highlighter "shared/%arg{1}/jsx"           region -recurse (?<![\w<])(<[a-zA-Z$_][\w$:.-]*|<>) (?<![\w<])(<[a-zA-Z$_][\w$:.-]*(?!\hextends)(?=[\s/>])(?!>\())|<>) (</.*?>|/>) regions
        add-highlighter "shared/%arg{1}/division"      region '[\w\)\]]\K(/|(\h+/\h+))' '(?=\w)' group # Help Kakoune to better detect /…/ literals

        # Regular expression flags are: g → global match, i → ignore case, m → multi-lines, u → unicode, y → sticky
        # https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp

        add-highlighter "shared/%arg{1}/literal/string"          default-region group
        add-highlighter "shared/%arg{1}/literal/string/"         fill string
        add-highlighter "shared/%arg{1}/literal/interpolation"   region -recurse \{ (?<!\\)(\\\\)*\$\{   \}  regions
        add-highlighter "shared/%arg{1}/literal/interpolation/"          default-region fill interpolation
        add-highlighter "shared/%arg{1}/literal/interpolation/content"   region -recurse \{ (?<!\\)(\\\\)*\$\{\K   (?=\})  ref %arg{1}
        add-highlighter "shared/%arg{1}/code/" regex \b(document|this|window|global|module)\b 1:field
        add-highlighter "shared/%arg{1}/code/" regex \b(false|null|true|undefined)\b 1:value
        add-highlighter "shared/%arg{1}/code/" regex "-?\b[0-9_]+([eE][+-]?[0-9_]+)?\b" 0:value
        add-highlighter "shared/%arg{1}/code/" regex "-?\b[0-9_]*\.[0-9_]+([eE][+-]?[0-9_]+)?\b" 0:value
        add-highlighter "shared/%arg{1}/code/" regex "-?\b[0-9]+n\b" 0:value
        add-highlighter "shared/%arg{1}/code/" regex "-?\b0x[0-9a-fA-F]+n?\b" 0:value

        # jsx: In well-formed xml the number of opening and closing tags match up regardless of tag name.
        #
        # We inline a small XML highlighter here since it anyway need to recurse back up to the starting highlighter.
        # To make things simple we assume that jsx is always enabled.

        add-highlighter "shared/%arg{1}/jsx/tag"  region -recurse <  <(?=[/a-zA-Z$_>-]) (?<!=)> regions
        add-highlighter "shared/%arg{1}/jsx/expr" region -recurse \{ \{             \}      ref %arg{1}

        add-highlighter "shared/%arg{1}/jsx/tag/base" default-region group
        add-highlighter "shared/%arg{1}/jsx/tag/double_string" region =\K" (?<!\\)(\\\\)*" fill string
        add-highlighter "shared/%arg{1}/jsx/tag/single_string" region =\K' (?<!\\)(\\\\)*' fill string
        add-highlighter "shared/%arg{1}/jsx/tag/expr" region -recurse \{ \{   \}           group

        add-highlighter "shared/%arg{1}/jsx/tag/base/" regex (\w+) 1:value
        add-highlighter "shared/%arg{1}/jsx/tag/base/" regex </?([\w_-]+) 1:identifier
        add-highlighter "shared/%arg{1}/jsx/tag/base/" regex </?([A-Z$_][\w$_]+) 1:type
        add-highlighter "shared/%arg{1}/jsx/tag/base/" regex (</?|/?>) 0:text

        add-highlighter "shared/%arg{1}/jsx/tag/expr/"   ref %arg{1}

        add-highlighter "shared/%arg{1}/code/" regex ((#|\b)[a-z_][$a-zA-Z0-9_]*)\b(?:\s*\() 1:function
        add-highlighter "shared/%arg{1}/code/" regex ([#]?[$_][$_0-9]*[a-z][$a-zA-Z0-9_]*)\b(?:\s*\() 1:function
        add-highlighter "shared/%arg{1}/code/" regex (?<![$])\b([A-Z][$a-zA-Z0-9_]*)\b 1:type
        add-highlighter "shared/%arg{1}/code/" regex (?<![\w_0-9])([$_][$_0-9]*[A-Z][$a-zA-Z0-9_]*)\b 1:type

        add-highlighter "shared/%arg{1}/code/" regex \b(Array|Boolean|Date|Function|Number|Object|RegExp|String|Symbol)\b 0:meta
        add-highlighter "shared/%arg{1}/code/" regex [<>*/+\-=%^!~~|&?:]+ 0:keyword
        add-highlighter "shared/%arg{1}/code/" regex ([$a-zA-Z_][$a-zA-Z0-9_]*)\b\??: 1:field
        add-highlighter "shared/%arg{1}/code/" regex (#[$a-zA-Z_][$a-zA-Z0-9_]*)\b 1:field

        # Keywords are collected at
        # https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Lexical_grammar#Keywords
        # https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/get
        # https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/set
        add-highlighter "shared/%arg{1}/code/" regex (^|[^.$]|\.\.\.)\b(async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|export|extends|finally|for|from|function|get|if|import|in|instanceof|let|new|of|return|set|static|super|switch|throw|try|typeof|var|void|while|with|yield)\b 2:keyword
    ~

    define-command -hidden javascript-load-languages %{
        evaluate-commands -draft %{
            try %{
                execute-keys '%s\b\K\w+(?=`)<ret>'
                evaluate-commands -itersel %{
                    try %{
                        require-module %val{selection}
                    }
                }
            }
        }
    }
§

# Aliases
# ‾‾‾‾‾‾‾
provide-module typescript %{
    require-module javascript_impl
    init-javascript-filetype typescript

    # Highlighting specific to TypeScript
    # ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
    add-highlighter shared/typescript/code/ regex \b(any|array|boolean|number|object|regexp|string|(unique\s+)?symbol|bigint|unknown|never)\b 0:type

    # Keywords grabbed from https://github.com/Microsoft/TypeScript/issues/2536
    add-highlighter shared/typescript/code/ regex \b(abstract|as|constructor|declare|enum|from|implements|interface|keyof|module|namespace|out|package|private|protected|public|readonly|static|type|satisfies|infer|is|never|override)\b 0:keyword
}

provide-module javascript %{
    require-module javascript_impl
    init-javascript-filetype javascript
}
