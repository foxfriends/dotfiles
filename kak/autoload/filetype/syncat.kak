# Detection

hook global BufCreate .*[.](syncat) %{
    set-option buffer filetype syncat-stylesheet
}

# Initialization

hook global WinSetOption filetype=syncat-stylesheet %[
    require-module syntax-syncat-stylesheet
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window syncat.+ }
]

hook -group syncat-highlight global WinSetOption filetype=syncat-stylesheet %{
    add-highlighter window/syncat ref syncat
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/syncat }
}

provide-module syntax-syncat-stylesheet %§

# Highlighters

add-highlighter shared/syncat                   regions
add-highlighter shared/syncat/items             default-region group
add-highlighter shared/syncat/styles            region "\{"    "\}"      group
add-highlighter shared/syncat/values            region ":"    ";"        group

add-highlighter shared/syncat/comment           region "//" "$"    ref comment
add-highlighter shared/syncat/string            region %{(?<!')"} (?<!\\)(\\\\)*"  fill string
add-highlighter shared/syncat/regex             region /    (?<!\\)(\\\\)*/i?      fill meta

add-highlighter shared/syncat/items/any         regex "\*" 0:keyword
add-highlighter shared/syncat/items/modifier    regex "&|>|~|\+" 0:keyword
add-highlighter shared/syncat/items/kind        regex \b([a-zA-Z0-9-_]+)\b 1:type
add-highlighter shared/syncat/items/capture     regex "<[a-zA-Z0-9-_]+>"  0:variable
add-highlighter shared/syncat/items/import      regex \bimport\b 0:keyword
add-highlighter shared/syncat/items/variable    regex "\$[a-zA-Z0-9-_]+\b"  0:variable
add-highlighter shared/syncat/items/            regex "//[^\n]*$"    0:comment

add-highlighter shared/syncat/values/important   regex "!" 0:keyword
add-highlighter shared/syncat/values/number      regex \b([0-9]+(\.[0-9]+)?)\b       1:value
add-highlighter shared/syncat/values/boolean     regex \b(true|false)\b              1:value
add-highlighter shared/syncat/values/hexcolor    regex (#[0-9a-fA-F]{6})\b           1:builtin
add-highlighter shared/syncat/values/namedcolor  regex \b(br)?(red|blue|green|yellow|purple|cyan|black|white)\b 0:builtin
add-highlighter shared/syncat/values/variable    regex "\$[a-zA-Z0-9-_]+\b"  0:variable
add-highlighter shared/syncat/styles/property    regex \b([a-zA-Z0-9-_]+)\s*: 1:function
add-highlighter shared/syncat/styles/            ref syncat/values
add-highlighter shared/syncat/styles/            regex "//[^\n]*$" 0:comment

§
