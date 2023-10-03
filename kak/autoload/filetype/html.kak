# http://w3.org/html
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*\.(html?|vue) %{
    set-option buffer filetype html
    set-option buffer tabstop 2
    set-option buffer indentwidth 2
    try %{
        check-cmd prettier
        set buffer formatcmd "prettier --stdin-filepath '%val{buffile}'"
    } catch %{ echo -debug %val{error} }
}

hook global BufCreate .*\.svelte %{
    set-option buffer filetype svelte
    set-option buffer tabstop 2
    set-option buffer indentwidth 2
    set-option buffer comment_line '//'
    try %{
        check-cmd prettier
        set buffer formatcmd "prettier --stdin-filepath '%val{buffile}'"
    } catch %{ echo -debug %val{error} }
}

hook global BufCreate .*\.xml %{
    set-option buffer filetype xml
    set-option buffer tabstop 2
    set-option buffer indentwidth 2
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=(html|xml|svelte) %{
    require-module html

    hook window ModeChange pop:insert:.* -group "%val{hook_param_capture_1}-trim-indent"  html-trim-indent
    hook window InsertChar '>' -group "%val{hook_param_capture_1}-indent" html-indent-on-greater-than
    hook window InsertChar \n -group "%val{hook_param_capture_1}-indent" html-indent-on-new-line

    hook -once -always window WinSetOption "filetype=.*" "
        remove-hooks window ""%val{hook_param_capture_1}-.+""
    "
}

hook -group html-highlight global WinSetOption filetype=(svelte|html|xml) %{
    add-highlighter "window/%val{hook_param_capture_1}" ref html
    hook -once -always window WinSetOption "filetype=.*" "
        remove-highlighter ""window/%val{hook_param_capture_1}""
    "
}


provide-module html %[
    try %{
        require-module css
        require-module javascript
        require-module typescript
    }

    # Highlighters
    # ‾‾‾‾‾‾‾‾‾‾‾‾
    add-highlighter shared/html regions
    add-highlighter shared/html/comment region <!--     -->                   ref comment
    add-highlighter shared/html/tag     region <     (?<!=)>                   regions
    add-highlighter shared/html/svelte  region \
        -recurse '\{\K' \
        '\{\K(@debug|@html|#key|#each|#if|#await|:else(\s+if)?|:catch|:then|/if|/each|/await|/key)' \
        (?=\}) \
        regions
    add-highlighter shared/html/style   region <style\b.*?>\K  (?=</style>)   ref css
    add-highlighter shared/html/typescript region %{<script\b.*lang=['"]?(typescript|ts)['"].*>\K} (?=</script>) ref typescript
    add-highlighter shared/html/javascript region <script\b[^>]*>\K (?=</script>)  ref javascript

    add-highlighter shared/html/svelte/base default-region group
    add-highlighter shared/html/svelte/base/  regex '[#/](if|each|await|key)\b'        0:keyword
    add-highlighter shared/html/svelte/base/  regex ':(then|else(\s+if)?|catch)\b' 0:keyword
    add-highlighter shared/html/svelte/base/  regex "@(html|debug)\b"              0:keyword
    add-highlighter shared/html/svelte/base/  regex "\b(as|then)\b"                0:keyword
    add-highlighter shared/html/svelte/ region '#each\b\K' '\b(?=as)' ref javascript
    add-highlighter shared/html/svelte/ region '#(key|if)\b\K' '(?=\})' ref javascript
    add-highlighter shared/html/svelte/ region '#await\b\K' '\b(?=then)|(?=\})' ref javascript
    add-highlighter shared/html/svelte/ region ':?(then|else\s+if)\b\K' '(?=\})'         ref javascript

    add-highlighter shared/html/tag/base          default-region group
    add-highlighter shared/html/tag/interpolation region -recurse '\{' '\{\K' '(?=\})'            ref javascript
    add-highlighter shared/html/tag/              region '"' (?<!\\)(\\\\)*"      fill string
    add-highlighter shared/html/tag/              region "'" "'"                  fill string

    add-highlighter shared/html/tag/base/ regex \b([a-zA-Z0-9:_-]+)=? 1:value
    add-highlighter shared/html/tag/base/ regex </?(\w+) 1:variable
    add-highlighter shared/html/tag/base/ regex <(!DOCTYPE(\h+\w+)+) 1:meta

    # Commands
    # ‾‾‾‾‾‾‾‾

    define-command -hidden html-trim-indent %{
        # remove trailing white spaces
        try %{ execute-keys -draft -itersel x s \h+$ <ret> d }
    }

    define-command -hidden html-indent-on-greater-than %[
        evaluate-commands -draft -itersel %[
            # align closing tag to opening when alone on a line
            try %[ execute-keys -draft <space> <a-h> s ^\h+<lt>/(\w+)<gt>$ <ret> {c<lt><c-r>1,<lt>/<c-r>1<gt> <ret> s \A|.\z <ret> 1<a-&> ]
        ]
    ]

    define-command -hidden html-indent-on-new-line %{
        evaluate-commands -draft -itersel %{
            # preserve previous line indent
            try %{ execute-keys -draft <semicolon> K <a-&> }
            # filter previous line
            try %{ execute-keys -draft k : html-trim-indent <ret> }
            # indent after lines ending with opening tag except when it starts with a closing tag
            try %{ execute-keys -draft k x <a-k> <lt>(?!area)(?!base)(?!br)(?!col)(?!command)(?!embed)(?!hr)(?!img)(?!input)(?!keygen)(?!link)(?!menuitem)(?!meta)(?!param)(?!source)(?!track)(?!wbr)(?!/)(?!>)[a-zA-Z0-9_-]+[^>]*?>$ <ret>jx<a-K>^\s*<lt>/<ret><a-gt> } }
    }
]
