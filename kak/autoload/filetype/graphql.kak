# Detection

hook global BufCreate .*[.](graphql|gql) %{
    set-option buffer filetype graphql
}

# Initialization

hook global WinSetOption filetype=graphql %[
    require-module graphql
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window graphql-.+ }
]

hook -group graphql-highlight global WinSetOption filetype=graphql %{
    add-highlighter window/graphql ref graphql
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/graphql }
}

provide-module graphql %§

# Highlighters

add-highlighter shared/graphql regions
add-highlighter shared/graphql/code default-region group
add-highlighter shared/graphql/comment region "^\s*#" "$" ref comment
add-highlighter shared/graphql/string region %{(?<!')"} (?<!\\)(\\\\)*" fill string
add-highlighter shared/graphql/multistring region %{"""} %{"""} fill string

add-highlighter shared/graphql/code/ regex \b(query|mutation|subscription|scalar|directive|on|implements|fragment)\b 1:keyword
add-highlighter shared/graphql/code/ regex \b((extend\s+)?(schema|type|interface|enum|input|union))\b 1:keyword

add-highlighter shared/graphql/code/ regex \b(QUERY|MUTATION|SUBSCRIPTION|FIELD|FRAGMENT_DEFINITION|FRAGMENT_SPREAD|INLINE_FRAGMENT|VARIABLE_DEFINITION)\b 1:value
add-highlighter shared/graphql/code/ regex \b(SCHEMA|SCALAR|OBJECT|FIELD_DEFINITION|ARGUMENT_DEFINITION|INTERFACE|UNION|ENUM|ENUM_VALUE|INPUT_OBJECT|INPUT_FIELD_DEFINITION)\b 1:value

add-highlighter shared/graphql/code/ regex \b([_A-Z][_0-9A-Za-z]*)\b 1:type
add-highlighter shared/graphql/code/ regex \b([_a-z][_0-9A-Za-z]*)\s*\( 1:function

add-highlighter shared/graphql/code/ regex \b(true|false)\b 1:value
add-highlighter shared/graphql/code/ regex \b(null)\b 1:value
add-highlighter shared/graphql/code/ regex -?\b(0|[1-9]\d*)(\.\d+)?([eE][+-]?\d+)? 0:value

add-highlighter shared/graphql/code/ regex \$[_A-Za-z][_0-9A-Za-z]* 0:field
add-highlighter shared/graphql/code/ regex @[_A-Za-z][_0-9A-Za-z]*(\(\))? 0:meta

§
