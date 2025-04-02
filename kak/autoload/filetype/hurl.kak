# https://hurl.dev
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*\.(hurl) %{
    set-option buffer filetype hurl
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=hurl %{
    require-module hurl
    require-module json

    hook window ModeChange pop:insert:.* -group hurl-trim-indent hurl-trim-indent
    hook window InsertChar \n -group hurl-indent hurl-indent-on-new-line

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window hurl-.+ }
}

hook -group hurl-load-languages global WinSetOption filetype=hurl %{
    hook -group hurl-load-languages window NormalIdle .* hurl-load-languages
    hook -group hurl-load-languages window InsertIdle .* hurl-load-languages
}

hook -group hurl-highlight global WinSetOption filetype=hurl %{
    add-highlighter window/hurl ref hurl
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/hurl }
}


provide-module hurl %§
    # Highlighters
    # ‾‾‾‾‾‾‾‾‾‾‾‾

    add-highlighter shared/hurl regions
    add-highlighter shared/hurl/code default-region group
    add-highlighter shared/hurl/comment region '#'   $                      ref comment
    add-highlighter shared/hurl/interpolation  region '\{\{'  '\}\}'        fill interpolation
    add-highlighter shared/hurl/string1 region  '"'   (?<!\\)(\\\\)*"   fill string
    add-highlighter shared/hurl/string2 region  "'"   "'"               fill string

    evaluate-commands %sh{
      languages="
        awk c cabal clojure coffee cpp css cucumber d diff dockerfile fish
        gas go haml haskell html ini java javascript json julia kak kickstart
        kotlin latex lisp lua makefile markdown moon objc perl pug python ragel
        ruby rust sass scala scss sh swift toml tupfile typescript yaml sql
        sml scheme graphql
      "
      for lang in ${languages}; do
        printf 'add-highlighter shared/hurl/fenced_%s region -match-capture ^(\\h*)```\\h*%s\\b   ^(\\h*)``` regions\n' "${lang}" "${lang}"
        printf 'add-highlighter shared/hurl/fenced_%s/ default-region fill meta\n' "${lang}"
        printf 'add-highlighter shared/hurl/fenced_%s/inner region ^\\h*```[^\\n]*\\K (?=```) ref %s\n' "${lang}" "${lang}"
      done
    }

    add-highlighter shared/hurl/code/ regex \b(GET|POST|PATCH|PUT|DELETE|OPTIONS|HEAD|HTTP)\b 1:keyword
    add-highlighter shared/hurl/code/ regex \b([0-9]+)\b 1:value
    add-highlighter shared/hurl/code/ regex (\[(Captures|Options|Query|QueryStringParams|FormParams|Form|MultipartFormData|Multipart|Cookies|Asserts|BasicAuth)\]) 1:meta
    add-highlighter shared/hurl/code/ regex \b(status|version|header|cookie|body|bytes|xpath|jsonpath|regex|sha256|md5|url|ip|variable|duration|certificate|base64Decode|base64Encode|count|daysAfterNow|daysBeforeNow|decode|format|htmlEscape|htmlUnescape|nth|regex|replace|split|toDate|toFloat|toInt|toString|urlDecode|urlEncode)\b 1:function
    add-highlighter shared/hurl/code/ regex (!=|==|<|>|>=|<=) 1:operator
    add-highlighter shared/hurl/code/ regex \b(contains|startsWith|endsWith|matches|exists|isBoolean|isCollection|isEmpty|isFloat|isInteger|isIsoDate|isNumber|isString|isIpv4|isIpv6)\b: 1:operator
    add-highlighter shared/hurl/code/ regex ^([a-zA-Z0-9_-]+): 1:variable

        
    # Commands
    # ‾‾‾‾‾‾‾‾

    define-command -hidden hurl-trim-indent %{
        # remove trailing white spaces
        try %{ execute-keys -draft -itersel x s \h+$ <ret> d }
    }

    define-command -hidden hurl-indent-on-new-line %{
        evaluate-commands -draft -itersel %{
            # copy comment prefix and following white spaces
            try %{ execute-keys -draft k x s ^\h*\K#\h* <ret> y gh j P }
            # preserve previous line indent
            try %{ execute-keys -draft <semicolon> K <a-&> }
            # filter previous line
            try %{ execute-keys -draft k : hurl-trim-indent <ret> }
        }
    }

    define-command -hidden hurl-load-languages %{
        evaluate-commands -draft %{ try %{
            execute-keys 'gtGbGls```\h*\K[^\s]+<ret>'
            evaluate-commands -itersel %{ require-module %val{selection} }
        }}
    }
§
