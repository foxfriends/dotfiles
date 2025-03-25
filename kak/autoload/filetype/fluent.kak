# https://projectfluent.org/
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*\.(ftl) %{
    set-option buffer filetype fluent
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=fluent %{
    require-module fluent

    hook window ModeChange pop:insert:.* -group fluent-trim-indent fluent-trim-indent
    hook window InsertChar \n -group fluent-indent fluent-indent-on-new-line

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window fluent-.+ }
}

hook -group fluent-highlight global WinSetOption filetype=fluent %{
    add-highlighter window/fluent ref fluent
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/fluent }
}


provide-module fluent %§
    # Highlighters
    # ‾‾‾‾‾‾‾‾‾‾‾‾

    add-highlighter shared/fluent regions
    add-highlighter shared/fluent/comment   region '#'   $            fill comment

    add-highlighter shared/fluent/main default-region group
    add-highlighter shared/fluent/main/key              regex "([\w\d_-]+)\s*(=)" 1:meta 2:operator

    add-highlighter shared/fluent/value     region '=\K'   "^(?=\S)"      regions
    add-highlighter shared/fluent/value/text        default-region      group
    add-highlighter shared/fluent/value/text/       fill string
    add-highlighter shared/fluent/value/text/       regex "\.([\w\d_-]+)\s*(=)" 1:meta 2:operator
    add-highlighter shared/fluent/value/interpolation   region -recurse \{ \{   \}  regions
    add-highlighter shared/fluent/value/interpolation/       default-region fill operator

    add-highlighter shared/fluent/value/interpolation/ins   region -recurse \{ \{\K   (?=\})  regions

    add-highlighter shared/fluent/value/interpolation/ins/case  region   "(\[[^\]]+\])"  $  regions
    add-highlighter shared/fluent/value/interpolation/ins/case/ default-region fill value
    add-highlighter shared/fluent/value/interpolation/ins/case/ region  "(\[[^\]]+\])\K" $ ref fluent/value

    add-highlighter shared/fluent/value/interpolation/ins/str   region   '"' (?<!\\)(?:\\\\)*" fill string

    add-highlighter shared/fluent/value/interpolation/ins/code  default-region group
    add-highlighter shared/fluent/value/interpolation/ins/code/ regex   "(\$[\w\d_]+)\b"  1:variable
    add-highlighter shared/fluent/value/interpolation/ins/code/ regex   "(-[\w\d_]+)\b"   1:meta
    add-highlighter shared/fluent/value/interpolation/ins/code/ regex   "(->|\*)"   1:operator
    add-highlighter shared/fluent/value/interpolation/ins/code/ regex   "([\w\d]+)(?=\()"   1:function
    add-highlighter shared/fluent/value/interpolation/ins/code/ regex   "(\d+|true|false)"   1:value
    add-highlighter shared/fluent/value/interpolation/ins/code/ regex   "(\d+)"   1:value
    add-highlighter shared/fluent/value/interpolation/ins/code/ regex   "(\w+:)"   1:meta

    # Commands
    # ‾‾‾‾‾‾‾‾

    define-command -hidden fluent-trim-indent %{
        # remove trailing white spaces
        try %{ execute-keys -draft -itersel x s \h+$ <ret> d }
    }

    define-command -hidden fluent-indent-on-new-line %{
        evaluate-commands -draft -itersel %{
            # copy comment prefix and following white spaces
            try %{ execute-keys -draft k x s ^\h*\K#\h* <ret> y gh j P }
            # preserve previous line indent
            try %{ execute-keys -draft <semicolon> K <a-&> }
            # filter previous line
            try %{ execute-keys -draft k : fluent-trim-indent <ret> }
        }
    }
§
