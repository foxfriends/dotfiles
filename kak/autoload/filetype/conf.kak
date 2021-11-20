# Detection

hook global BufCreate .*[.](conf) %{
    set-option buffer filetype conf
}

# Initialization

hook global WinSetOption filetype=conf %[
    require-module conf
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window conf-.+ }
]

hook -group conf-highlight global WinSetOption filetype=conf %{
    add-highlighter window/conf ref conf
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/conf }
}

provide-module conf %§

# Highlighters

add-highlighter shared/conf                   regions
add-highlighter shared/conf/props             default-region group
add-highlighter shared/conf/comment           region "^\s*#" "$"    ref comment

add-highlighter shared/conf/props/property    regex (?S)^\s*([a-zA-Z_\-0-9]+)\s+(.*)$       1:identifier 2:string
add-highlighter shared/conf/props/number      regex \b([0-9]+(\.[0-9]+)?)\b                 1:value
add-highlighter shared/conf/props/color       regex (#[0-9a-fA-F]{3}|#[0-9a-fA-F]{6})\b   1:builtin

§
