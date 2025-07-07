# Detection
hook global BufCreate .*[.](kdl) %{
    set-option buffer filetype kdl
}

# Initialization
hook global WinSetOption filetype=kdl %{
    require-module kdl
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window kdl-.+
    }
}

hook -group kdl-highlight global WinSetOption filetype=kdl %{
    add-highlighter window/kdl ref kdl
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/kdl }
}

provide-module kdl %§
    # Highlighters
    add-highlighter shared/kdl                   regions
    add-highlighter shared/kdl/props             default-region group
    add-highlighter shared/kdl/comment           region "//" "$"                        ref comment
    add-highlighter shared/kdl/slash_dash        region "/-" "$"                        ref comment
    add-highlighter shared/kdl/slash_dash_child  region -recurse "\{" "/-.*\{$" "\}"    ref comment
    add-highlighter shared/kdl/slash_star        region -recurse "/\*" "/\*" "\*/"      ref comment
    add-highlighter shared/kdl/string            region %{(?<!')"} %{(?<!\\)(\\\\)*"}       fill string
    add-highlighter shared/kdl/raw_string        region -match-capture %{(#*)"} %{"(#*)}    fill string

    add-highlighter shared/kdl/props/property    regex (?S)^\s*([a-zA-Z_\-0-9]+)              1:keyword
    add-highlighter shared/kdl/props/number      regex \b([0-9_]+(\.[0-9_]+)(e-?[0-9_]+)?)\b  1:value
    add-highlighter shared/kdl/props/numberhex   regex \b(0x[0-9A-Fa-f_]+)\b                  1:value
    add-highlighter shared/kdl/props/constant    regex (#(true|false|null|inf|\-inf|nan))\b   1:value
§
