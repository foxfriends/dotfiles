# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*/([.]?[jJ]ustfile|.*\.[jJ]ust(file)?) %{
    set-option buffer filetype justfile
}

hook global WinSetOption filetype=justfile %{
    require-module justfile
    require-module sh

    hook window ModeChange pop:insert:.* -group justfile-trim-indent justfile-trim-indent
    hook window InsertChar \n -group justfile-insert just-insert-on-new-line
    hook window InsertChar \n -group justfile-indent just-indent-on-new-line
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window justfile-.+ }
}

hook -group justfile-highlight global WinSetOption filetype=justfile %{
    add-highlighter window/justfile ref justfile
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/justfile }
}


provide-module justfile %{

# Indentation
# ‾‾‾‾‾‾‾‾‾‾‾

define-command -hidden justfile-trim-indent %{
    evaluate-commands -no-hooks -draft -itersel %{
        execute-keys x
        # remove trailing white spaces
        try %{ execute-keys -draft s \h + $ <ret> d }
    }
}

define-command -hidden just-insert-on-new-line %{
    # copy '#' comment prefix and following white spaces
    try %{ execute-keys -draft k x s ^\h*//\h* <ret> y jgh P }
}

define-command -hidden just-indent-on-new-line %{
     evaluate-commands -draft -itersel %{
        # preserve previous line indent
        try %{ execute-keys -draft <semicolon>K<a-&> }
        # cleanup trailing white spaces on previous line
        try %{ execute-keys -draft kx s \h+$ <ret>"_d }
    }
}

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/justfile regions

add-highlighter shared/justfile/comment     region '#' '$'                  ref doc_comment
add-highlighter shared/justfile/inline      region '`' '`'                  ref sh

add-highlighter shared/justfile/content default-region group
add-highlighter shared/justfile/content/recipe regex '^@?([\w-]+)([^\n]*):(?!=)([^\n]*)' 1:function 3:keyword
add-highlighter shared/justfile/content/assignments regex ^([\w-]+)\h*:= 1:variable
add-highlighter shared/justfile/content/operator regex '(^@|:=|!=|==|\|\||\+)' 1:operator
add-highlighter shared/justfile/content/keywords regex '\b(if|else|set|export|unexport)\b' 1:keyword
add-highlighter shared/justfile/content/constants regex '\b(true|false)\b' 1:keyword
add-highlighter shared/justfile/content/attribute1 regex '\[\w+\]'  0:meta
add-highlighter shared/justfile/content/attribute2 regex '(\[[\w-]+:)[^\]]*(\])'  1:meta 2:meta
add-highlighter shared/justfile/content/function   regex \b([a-zA-Z_0-9]*)\s*(?=\() 1:function
add-highlighter shared/justfile/content/argument   regex \b([a-zA-Z_0-9]*)= 1:variable

add-highlighter shared/justfile/content/subregions regions
add-highlighter shared/justfile/content/subregions/comment region '#' '$' fill comment
add-highlighter shared/justfile/content/subregions/double  region '"' (?<!\\)(\\\\)*" fill string
add-highlighter shared/justfile/content/subregions/single  region "'" (?<!\\)(\\\\)*' fill string

add-highlighter shared/justfile/body  region '^\h+' '^(?=[^\h])' group
add-highlighter shared/justfile/body/interpreters regions
add-highlighter shared/justfile/body/interpreters/defaultshell default-region group
add-highlighter shared/justfile/body/interpreters/defaultshell/ ref sh
add-highlighter shared/justfile/body/interpreters/defaultshell/ regex '^\h+(@)' 1:operator

add-highlighter shared/justfile/body/interpreters/bash region '^\h+#!\h?/usr/bin/env bash' '^(?=[^\h])' ref sh
add-highlighter shared/justfile/body/interpreters/sh region '^\h+#!\h?/usr/bin/env sh' '^(?=[^\h])' ref sh

add-highlighter shared/justfile/body/ regex '(\{\{)([\w-]+(?=\(\)))(\}\})' 1:operator 2:variable 3:operator


}
