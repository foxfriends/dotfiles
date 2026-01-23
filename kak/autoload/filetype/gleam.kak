# https://gleam.run
# -----------------

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](gleam) %{
    set-option buffer filetype gleam
    set buffer tabstop 2
    set buffer indentwidth 2
    set-option buffer formatcmd "gleam format - --stdin"
}

hook global BufSetOption filetype=gleam %{
    set-option buffer comment_line '//'
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=gleam %{
    require-module gleam

    hook window ModeChange pop:insert:.* -group gleam-trim-indent gleam-trim-indent
    hook window InsertChar \n -group gleam-indent gleam-indent-on-new-line
    hook window InsertChar \n -group gleam-insert gleam-insert-on-new-line

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window gleam-.+ }
}

hook -group gleam-highlight global WinSetOption filetype=gleam %{
    add-highlighter window/gleam ref gleam
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/gleam }
}

provide-module gleam %§

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/gleam regions
add-highlighter shared/gleam/code default-region group
add-highlighter shared/gleam/string         region %{(?<!')"} (?<!\\)(\\\\)*"              fill string
add-highlighter shared/gleam/comment        region '//'     '$' ref comment
add-highlighter shared/gleam/doc_comment    region "///"    "$" ref doc_comment

add-highlighter shared/gleam/code/ regex \b([0-9]+)\b 1:value
add-highlighter shared/gleam/code/ regex \b(0x[0-9A-Fa-f]+)\b 1:value
add-highlighter shared/gleam/code/ regex \b(0o[0-7]+)\b 1:value
add-highlighter shared/gleam/code/ regex \b(0b[01]+)\b 1:value
add-highlighter shared/gleam/code/ regex ([+\-*/%<>]|>=|<=)[.]? 0:operator
add-highlighter shared/gleam/code/ regex (==|!=) 0:operator
add-highlighter shared/gleam/code/ regex (<>) 0:operator
add-highlighter shared/gleam/code/ regex (&&|\|\|) 0:operator
add-highlighter shared/gleam/code/ regex \b(True|False|Nil)\b 0:value
add-highlighter shared/gleam/code/ regex \b(Bool|Int|String|Float|BitArray)\b 0:builtin
add-highlighter shared/gleam/code/ regex \b([A-Z][a-zA-Z0-9_]*)\b 1:type

add-highlighter shared/gleam/code/ regex (\.\.|\|>|\|) 0:operator
add-highlighter shared/gleam/code/ regex (:|->) 0:operator
add-highlighter shared/gleam/code/ regex (<<|>>) 0:operator

add-highlighter shared/gleam/code/ regex \b([a-z_][a-zA-Z_0-9]*)\s*(?=\() 1:function
add-highlighter shared/gleam/code/ regex \b(as|assert|case|const|fn|if|import|let|opaque|panic|pub|todo|type|use)\b 0:keyword
add-highlighter shared/gleam/code/ regex \b(delegate)\b 0:error
add-highlighter shared/gleam/code/ regex (@[a-zA-Z][a-zA-Z0-9_]*)\b 1:meta


# Commands
# ‾‾‾‾‾‾‾‾

define-command -hidden gleam-trim-indent %{
    # remove trailing white spaces
    try %{ execute-keys -draft -itersel x s \h+$ <ret> d }
}

define-command -hidden gleam-insert-on-new-line %[
    evaluate-commands -no-hooks -draft -itersel %[
        # copy '//' comment prefix and following white spaces
        try %{ execute-keys -draft k x s ^\h*\K///?\h* <ret> y jgi P }
        # wisely add end structure
        # evaluate-commands -save-regs x %[
        #     try %{ execute-keys -draft k x s ^ \h + <ret> \" x y } catch %{ reg x '' }
        #     try %[
        #         evaluate-commands -draft %[
        #             # Check if previous line opens a block
        #             execute-keys -draft kx <a-k>^<c-r>x(.+\bdo$)<ret>
        #             # Check that we do not already have an end for this indent level which is first set via `gleam-indent-on-new-line` hook
        #             execute-keys -draft }i J x <a-K> ^<c-r>x(end|else)[^0-9A-Za-z_!?]<ret>
        #         ]
        #         execute-keys -draft o<c-r>xend<esc> # insert a new line with containing end
        #     ]
        # ]
    ]
]

define-command -hidden gleam-indent-on-new-line %{
    evaluate-commands -draft -itersel %{
        # preserve previous line indent
        try %{ execute-keys -draft <semicolon> K <a-&> }
        # indent after line ending with:
        # try %{ execute-keys -draft k x <a-k> (\bdo|\belse|->)$ <ret> & }
        # filter previous line
        try %{ execute-keys -draft k : gleam-trim-indent <ret> }
        # indent after lines ending with do or ->
        try %{ execute-keys -draft <semicolon> k x <a-k> ^.+(\bdo|->)$ <ret> j <a-gt> }
    }
}

§
