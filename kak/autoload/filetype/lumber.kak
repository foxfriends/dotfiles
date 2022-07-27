hook global BufCreate .*\.(lumber) %{
    set-option buffer filetype lumber
}

hook global WinSetOption filetype=lumber %{
    require-module lumber
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window lumber-.+ }
}

hook -group lumber-highlight global WinSetOption filetype=lumber %{
    add-highlighter window/lumber ref lumber
    hook window InsertChar \n -group lumber-indent lumber-indent-on-new-line
    # correct comment-block behavior
    set-option window comment_block_begin '/*'
    set-option window comment_block_end '*/'
    set-option window comment_line '//'
}

provide-module lumber %{
    add-highlighter shared/lumber regions
    add-highlighter shared/lumber/code          default-region group
    add-highlighter shared/lumber/double_string region %{(?<!\\)(?:\\\\)*\K"} %{(?<!\\)(?:\\\\)*"} fill string
    add-highlighter shared/lumber/single_string region %{(?<!\\)(?:\\\\)*\K'} %{(?<!\\)(?:\\\\)*'} fill string
    add-highlighter shared/lumber/comment       region '//' '$' ref comment
    add-highlighter shared/lumber/block_comment region -recurse '/\*' '/\*' '\*/'    ref comment

    add-highlighter shared/lumber/code/operator   regex '(:?:-|\.|!|\?|,|;|->>?|<-|::)' 0:operator
    add-highlighter shared/lumber/code/function   regex \b([a-z][a-zA-Z0-9_]*)\s*(?=\() 1:function
    add-highlighter shared/lumber/code/module     regex ([@~]?[a-z][a-zA-Z0-9_]*)(?=::) 1:module
    add-highlighter shared/lumber/code/module_    regex ([@~][a-z][a-zA-Z0-9_]*) 1:module
    add-highlighter shared/lumber/code/variable   regex \b([A-Z][a-zA-Z0-9_]*)\b 1:variable
    add-highlighter shared/lumber/code/integer    regex \b[0-9]+\b 0:value
    add-highlighter shared/lumber/code/decimal    regex \b[0-9]+\.[0-9]+ 0:value
    add-highlighter shared/lumber/code/directive  regex \b(mod|pub|inc|mut|use)\b 1:meta
    add-highlighter shared/lumber/code/handle     regex \b([a-z][a-zA-Z0-9_]*/\d+)(:[a-z][a-zA-Z0-9_]*(/\d+)?)*\b 0:value
    add-highlighter shared/lumber/code/module-def regex \bmod\(\s*([a-z][a-zA-Z0-9_]*)\s*\) 1:module

    define-command -hidden lumber-indent-on-new-line %~
        evaluate-commands -draft -itersel %[
            # copy // comments prefix and following white spaces
            try %{ execute-keys -draft k x s ^\h*\K\/\/\h* <ret> y gh j P }
            # preserve previous line indent
            try %{ execute-keys -draft \; K <a-&> }
            # filter previous line
            try %{ execute-keys -draft -itersel k x s \h+$ <ret> d }
            # indent after lines ending with ':-' or '<-'
            try %{ execute-keys -draft k x <a-k> (:-|\<-)\h*$ <ret> j <a-gt> }
        ]
    ~
}
