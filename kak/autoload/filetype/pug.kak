# Note: jade is changing its name to pug (https://github.com/pugjs/pug/issues/2184)
# This appears to be a work in progress -- the pug-lang domain is parked, while
# the jade-lang one is active. This highlighter will recognize .pug and .jade extensions,

# http://jade-lang.com (will be http://pug-lang.com)
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](pug|jade) %{
    set-option buffer filetype pug
    set buffer tabstop 2
    set buffer indentwidth 2
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=pug %{
    require-module javascript
    require-module pug

    hook window ModeChange pop:insert:.* -group pug-trim-indent  pug-trim-indent
    hook window InsertChar \n -group pug-indent pug-indent-on-new-line

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window pug-.+ }
}

hook -group pug-highlight global WinSetOption filetype=pug %{
    add-highlighter window/pug ref pug
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/pug }
}


provide-module pug %§

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/pug regions
add-highlighter shared/pug/code          default-region group

add-highlighter shared/pug/attribute     region -recurse \( \(            \)        regions
add-highlighter shared/pug/attribute/r   default-region group
add-highlighter shared/pug/attribute/r/  ref javascript
add-highlighter shared/pug/attribute/r/     regex   \b([a-zA-Z_-]+)= 1:variable

add-highlighter shared/pug/text                 region ^\h*\|\s     $                       regions
add-highlighter shared/pug/text/interpolation   region -recurse '#\{' '#\{' '\}'            fill variable
add-highlighter shared/pug/text/r               default-region group
add-highlighter shared/pug/text/r/              regex ^\h*(\|) 1:meta

add-highlighter shared/pug/comment       region //           $                      ref comment

add-highlighter shared/pug/puglang          region ^\h*\b(\block|extends|include|append|prepend|if|unless|else|case|when|default|each|while|mixin)\b $ group
add-highlighter shared/pug/puglang/         regex   \b(\block|extends|include|append|prepend|if|unless|else|case|when|default|each|while|mixin|of|in)\b 0:keyword
add-highlighter shared/pug/puglang/         regex   extends\h+(.*)$ 1:string

# TODO: bring these features back?
# add-highlighter shared/pug/javascript    region ^\h*[-=!]    $                      ref javascript
# TODO: subdocument CSS/Js highlighting

# Filters
# ‾‾‾‾‾‾‾

add-highlighter shared/pug/code/tag         regex   (^\h*|:\h*)([A-Za-z][A-Za-z0-9_-]*)?((\.[A-Za-z][A-Za-z0-9_-]*)*)(#[A-Za-z][A-Za-z0-9_-]*)?([./]?)      1:keyword 2:variable 3:value 5:function 6:keyword

# Commands
# ‾‾‾‾‾‾‾‾

define-command -hidden pug-trim-indent %{
    # remove trailing white spaces
    try %{ execute-keys -draft -itersel <a-x> s \h+$ <ret> d }
}

define-command -hidden pug-indent-on-new-line %{
    evaluate-commands -draft -itersel %{
        # preserve previous line indent
        try %{ execute-keys -draft <semicolon> K <a-&> }
        # filter previous line
        try %{ execute-keys -draft k : pug-trim-indent <ret> }
        # copy '//', '|', '-' or '(!)=' prefix and following whitespace
        try %{ execute-keys -draft k <a-x> s ^\h*\K[/|!=-]{1,2}\h* <ret> y gh j P }
        # indent unless we copied something above
        try %{ execute-keys -draft <a-gt> <space> b s \S <ret> g l <a-lt> }
    }
}

§
