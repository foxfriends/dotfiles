# https://github.com/foxfriends/embedded-typescript
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](ets) %{
    set-option buffer filetype ets
    set buffer tabstop 2
    set buffer indentwidth 2
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=ets %{
    require-module ets
}

hook -group markdown-highlight global WinSetOption filetype=ets %{
    add-highlighter window/ets ref ets
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/ets }
}


provide-module ets %§
    # Highlighters
    # ‾‾‾‾‾‾‾‾‾‾‾‾
    require-module typescript

    add-highlighter shared/ets regions
    add-highlighter shared/ets/header           region ^---$ ^---$          regions
    add-highlighter shared/ets/header/          default-region              fill meta
    add-highlighter shared/ets/header/          region ^---$\K (?=---)      ref typescript

    add-highlighter shared/ets/interpolation    region "<%%[=|]?" "%%>"       regions
    add-highlighter shared/ets/interpolation/   default-region              fill interpolation
    add-highlighter shared/ets/interpolation/   region "<%%[=|]?\K" "(?=%%>)" ref typescript
    add-highlighter shared/ets/text             default-region group
    add-highlighter shared/ets/text/glue        regex <>             0:keyword
§
