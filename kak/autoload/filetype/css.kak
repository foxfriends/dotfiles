# http://w3.org/Style/CSS
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](css) %{
    set-option buffer filetype css
    set buffer tabstop 2
    set buffer indentwidth 2
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=css %[
    require-module css

    try {
        require-module detection
        check-cmd stylelint
        set buffer lintcmd 'run() { cat "$1" | stylelint --formatter json --stdin --stdin-filename "$kak_buffile" | "${kak_config}/scripts/stylelint-format"; } && run'
        lint-enable
    }

    hook window ModeChange pop:insert:.* -group css-trim-indent  css-trim-indent
    hook window InsertChar \n -group css-indent css-indent-on-new-line
    hook window InsertChar \} -group css-indent css-indent-on-closing-curly-brace
    set-option buffer extra_word_chars '_' '-'

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window css-.+ }
]

hook -group css-highlight global WinSetOption filetype=css %{
    add-highlighter window/css ref css
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/css }
}


provide-module css %[
    # Highlighters
    # ‾‾‾‾‾‾‾‾‾‾‾‾

    add-highlighter shared/css regions
    add-highlighter shared/css/selector    default-region group
    add-highlighter shared/css/declaration region -recurse [{] [{]        [}]  regions
    add-highlighter shared/css/comment     region /[*]       [*]/ ref comment
    add-highlighter shared/css/import      region (@import\b)  ";"  regions
    add-highlighter shared/css/media       region (@media\b)   [{]  regions

    add-highlighter shared/css/import/base          default-region group
    add-highlighter shared/css/import/double_string region '"' (?<!\\)(\\\\)*" fill string
    add-highlighter shared/css/import/single_string region "'" "'"             fill string
    add-highlighter shared/css/import/comment       region /[*] [*]/           ref comment

    add-highlighter shared/css/import/base/ regex      "@import"        0:keyword
    add-highlighter shared/css/import/base/ regex ([A-Za-z0-9_-]+)\h*\( 1:builtin
    add-highlighter shared/css/import/base/ regex [a-zA-Z0-9_-]+        0:constant

    add-highlighter shared/css/declaration/base          default-region group
    add-highlighter shared/css/declaration/double_string region '"' (?<!\\)(\\\\)*" fill string
    add-highlighter shared/css/declaration/single_string region "'" "'"             fill string
    add-highlighter shared/css/declaration/comment       region /[*] [*]/           ref comment
    add-highlighter shared/css/declaration/nested        region \s*&\s* (?=\{) ref css/selector

    add-highlighter shared/css/declaration/base/ regex \b(inherit|initial|unset)\b 1:keyword
    add-highlighter shared/css/declaration/base/ regex \b(none|auto)\b 1:keyword
    add-highlighter shared/css/declaration/base/ regex \b(inline-block|inline-flex|inline-grid|block|flex|grid)\b 1:keyword
    add-highlighter shared/css/declaration/base/ regex \b(visible|hidden)\b 1:keyword
    add-highlighter shared/css/declaration/base/ regex \b(center|left|right|justify|middle|top|baseline|bottom)\b 1:keyword
    add-highlighter shared/css/declaration/base/ regex \b(sans-serif|serif|cursive|mono|fantasy)\b 1:keyword
    add-highlighter shared/css/declaration/base/ regex \b(border-box|content-box)\b 1:keyword
    add-highlighter shared/css/declaration/base/ regex \b(pointer|default)\b 1:keyword
    add-highlighter shared/css/declaration/base/ regex \b(fixed|absolute|relative|static)\b 1:keyword
    add-highlighter shared/css/declaration/base/ regex \b(solid|dashed|dotted|inset)\b 1:keyword
    add-highlighter shared/css/declaration/base/ regex \b(bold|bolder|light|lighter|boldest|lightest)\b 1:keyword
    add-highlighter shared/css/declaration/base/ regex \b(repeat|no-repeat|repeat-x|repeat-y)\b 1:keyword
    add-highlighter shared/css/declaration/base/ regex \b(underline|italic|oblique|overline|strike)\b 1:keyword

    add-highlighter shared/css/declaration/base/ regex (#[0-9A-Fa-f]+)|((\d*\.)?\d+(ch|cm|em|ex|mm|pc|pt|px|rem|vh|vmax|vmin|vw|%|s|ms|fr)?) 0:value
    add-highlighter shared/css/declaration/base/ regex ([A-Za-z0-9_-]+)\h*\( 1:builtin
    add-highlighter shared/css/declaration/base/ regex (--[a-zA-Z0-9_-]+)    1:variable
    add-highlighter shared/css/declaration/base/ regex !important            0:keyword
    add-highlighter shared/css/declaration/base/ regex ([A-Za-z0-9_-]+)\h*:  1:builtin

    add-highlighter shared/css/media/base          default-region group
    add-highlighter shared/css/media/double_string region '"' (?<!\\)(\\\\)*" fill string
    add-highlighter shared/css/media/single_string region "'" "'"             fill string
    add-highlighter shared/css/media/comment       region /[*] [*]/           ref comment

    add-highlighter shared/css/media/base/ regex      "@media"  0:keyword
    add-highlighter shared/css/media/base/ regex      "and"  0:keyword
    add-highlighter shared/css/media/base/ regex (#[0-9A-Fa-f]+)|((\d*\.)?\d+(ch|cm|em|ex|mm|pc|pt|px|rem|vh|vmax|vmin|vw|%|s|ms|fr|deg)?) 0:value

    add-highlighter shared/css/selector/ regex         [*+>~&\[\]=$]       0:keyword
    add-highlighter shared/css/selector/ regex         [A-Za-z0-9_-]+      0:variable
    add-highlighter shared/css/selector/ regex      [#][A-Za-z0-9_-]+      0:function
    add-highlighter shared/css/selector/ regex      [.][A-Za-z0-9_-]+      0:type
    add-highlighter shared/css/selector/ regex      [:]{1,2}[a-zA-Z0-9_-]+ 0:value
    add-highlighter shared/css/selector/ regex         '@keyframes\b'      0:keyword

    # Commands
    # ‾‾‾‾‾‾‾‾

    define-command -hidden css-trim-indent %{
        # remove trailing white spaces
        try %{ execute-keys -draft -itersel <a-x> s \h+$ <ret> d }
    }

    define-command -hidden css-indent-on-new-line %[
        evaluate-commands -draft -itersel %[
            # preserve previous line indent
            try %[ execute-keys -draft <semicolon> K <a-&> ]
            # filter previous line
            try %[ execute-keys -draft k : css-trim-indent <ret> ]
            # indent after lines ending with with {
            try %[ execute-keys -draft k <a-x> <a-k> \{$ <ret> j <a-gt> ]
        ]
    ]

    define-command -hidden css-indent-on-closing-curly-brace %[
        evaluate-commands -draft -itersel %[
            # align to opening curly brace when alone on a line
            try %[ execute-keys -draft <a-h> <a-k> ^\h+\}$ <ret> m s \A|.\z <ret> 1<a-&> ]
        ]
    ]
]
