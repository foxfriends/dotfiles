# Extremely basic prolog highlighting for kakoune
# Updated 2018-05-14

hook global BufCreate .*\.(pl|plt) %{
    set-option buffer filetype prolog
}

hook global WinSetOption filetype=prolog %{
    require-module prolog
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window prolog-.+ }
}

hook -group prolog-highlight global WinSetOption filetype=prolog %{
    add-highlighter window/prolog ref prolog
    hook window InsertChar \n -group prolog-indent prolog-indent-on-new-line
    # correct comment-block behavior
    set-option window comment_block_begin '/*'
    set-option window comment_block_end '*/'
    set-option window comment_line '%'
}

provide-module prolog %{
    add-highlighter shared/prolog regions
    add-highlighter shared/prolog/code          default-region group
    add-highlighter shared/prolog/double_string region %{(?<!\\)(?:\\\\)*\K"} %{(?<!\\)(?:\\\\)*"} fill string
    add-highlighter shared/prolog/single_string region %{(?<!\\)(?:\\\\)*\K'} %{(?<!\\)(?:\\\\)*'} fill string
    add-highlighter shared/prolog/comment       region '(?<!\$)%' '$' ref comment
    add-highlighter shared/prolog/block_comment region '/\*' '\*/'    ref comment

    add-highlighter shared/prolog/code/ regex (:-|\.) 0:operator
    add-highlighter shared/prolog/code/ regex \bis\b 0:operator
    add-highlighter shared/prolog/code/ regex \b(([a-z][a-zA-Z0-9_]*):)?([a-z][a-zA-Z0-9_]*)\s*(?=\() 2:module 3:function
    add-highlighter shared/prolog/code/ regex \b([A-Z][a-zA-Z0-9_]*)\b 1:variable
    add-highlighter shared/prolog/code/ regex \b[0-9]+ 0:value
    add-highlighter shared/prolog/code/ regex \b[0-9]+\.[0-9]+ 0:value

    # largely taken from https://github.com/mawww/kakoune/blob/
    # 43f50c0852a6f95abbcdf81f9d3bab9eeefbde0d/rc/base/rust.kak#L42
    define-command -hidden prolog-indent-on-new-line %~
        evaluate-commands -draft -itersel %<
            # copy % comments prefix and following white spaces
            try %{ execute-keys -draft k x s ^\h*\K%\h* <ret> y gh j P }
            # preserve previous line indent
            try %{ execute-keys -draft \; K <a-&> }
            # filter previous line
            try %{ execute-keys -draft -itersel k x s \h+$ <ret> d }
            # indent after lines ending with ':-'
            try %{ execute-keys -draft k x <a-k> :-\h*$ <ret> j <a-gt> }
        >
    ~
}
