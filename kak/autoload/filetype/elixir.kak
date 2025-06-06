# http://elixir-lang.org
# ----------------------

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](ex|exs) %{
    set-option buffer filetype elixir
    set buffer tabstop 2
    set buffer indentwidth 2
    set-option window lintcmd "mix credo list --config-file=.credo.exs --format=flycheck --ignore-checks='Elixir.CredoNaming.Check.Consistency.ModuleFilename'"
}

hook global BufCreate .*[.]html[.][hl]?eex %{
    set-option buffer filetype eex
    set buffer tabstop 2
    set buffer indentwidth 2
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=elixir %{
    require-module elixir

    hook window ModeChange pop:insert:.* -group elixir-trim-indent elixir-trim-indent
    hook window InsertChar \n -group elixir-indent elixir-indent-on-new-line
    hook window InsertChar \n -group elixir-insert elixir-insert-on-new-line

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window elixir-.+ }
}

hook -group elixir-highlight global WinSetOption filetype=elixir %{
    add-highlighter window/elixir ref elixir
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/elixir }
}

hook global WinSetOption filetype=eex %{
    require-module eex

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window eex-.+ }
}

hook -group eex-highlight global WinSetOption filetype=eex %{
    add-highlighter window/eex ref eex
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/eex }
}

provide-module eex %{
require-module html
require-module elixir

add-highlighter shared/eex regions
add-highlighter shared/eex/html default-region ref html
add-highlighter shared/eex/comment region '<%#' '%>' ref comment
add-highlighter shared/eex/quote region '<%%' '%>' ref html
add-highlighter shared/eex/code region '<%=?' '%>' ref elixir
}

provide-module elixir %§

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/elixir regions
add-highlighter shared/elixir/code default-region group
add-highlighter shared/elixir/double_string region -match-capture ("""|") (?<!\\)(?:\\\\)*("""|") regions
add-highlighter shared/elixir/single_string region "'" "(?<!\\)(?:\\\\)*'" fill string
add-highlighter shared/elixir/regex         region ~r/    (?<!\\)(\\\\)*/[gimuy]* fill meta
add-highlighter shared/elixir/comment region '#' '$' ref comment

add-highlighter shared/elixir/leex region -match-capture '~L("""|")' '(?<!\\)(?:\\\\)*("""|")' ref eex

add-highlighter shared/elixir/double_string/base default-region fill string
add-highlighter shared/elixir/double_string/interpolation region -recurse \{ \Q#{ \} regions
add-highlighter shared/elixir/double_string/interpolation/          default-region fill interpolation
add-highlighter shared/elixir/double_string/interpolation/content   region -recurse \{ \Q#{\E\K   (?=\})  ref elixir

add-highlighter shared/elixir/code/ regex '~[a-zA-Z]\(.*?[^\\]\)' 0:string
add-highlighter shared/elixir/code/ regex '\b\d+[\d_]*\b' 0:value
add-highlighter shared/elixir/code/ regex \b(0x[0-9A-Fa-f]+)\b 1:value
add-highlighter shared/elixir/code/ regex \b(0o[0-7]+)\b 1:value
add-highlighter shared/elixir/code/ regex \b(0b[01]+)\b 1:value
add-highlighter shared/elixir/code/ regex \b(true|false|nil)\b 0:value
add-highlighter shared/elixir/code/ regex (->|<-|<<|>>|=>|\|>|::|=|&|%?\{|\}|\+\+?|-|\*|/|<>|&&|\|\||==|===|!=|<=|>=|>|<) 0:operator
add-highlighter shared/elixir/code/ regex \b(not|or|and|in)\b 1:operator
add-highlighter shared/elixir/code/ regex \b(require|alias|use|import)\b 0:keyword
add-highlighter shared/elixir/code/ regex \b(__MODULE__|__DIR__|__ENV__|__CALLER__)\b 0:field
add-highlighter shared/elixir/code/ regex (&\d+)\b 0:field
add-highlighter shared/elixir/code/ regex (\^)([\w_]+)\b 1:keyword 2:field
add-highlighter shared/elixir/code/ regex '%[_A-Z][\w_]+\b' 0:type
add-highlighter shared/elixir/code/ regex '(?<![%:])\b[A-Z][\w_]+(?!:)\b' 0:module
add-highlighter shared/elixir/code/ regex ':[\w_]+\b[!?]?' 0:builtin
add-highlighter shared/elixir/code/ regex '([\w_]+[!?]?):' 1:builtin 0:operator
add-highlighter shared/elixir/code/ regex '(:[\w_]+)(\.)' 1:module
add-highlighter shared/elixir/code/ regex '\b_\b' 0:default+d
add-highlighter shared/elixir/code/ regex '\b_[a-zA-Z0-9][\w_]*\b' 0:default+d
add-highlighter shared/elixir/code/ regex '@[\w_]+\b' 0:+d@keyword
add-highlighter shared/elixir/code/ regex \b([a-z_][a-zA-Z_0-9]*[!?]?)\s*(?=\() 1:function
add-highlighter shared/elixir/code/ regex \b(test|describe|setup)\b 0:builtin
add-highlighter shared/elixir/code/ regex \b(assert|assert_in_delta|assert_raise|assert_receive|assert_received|catch_error|catch_exit|catch_throw|flunk|refute|refute_in_delta|refute_receive|refute_received)\b 0:builtin
add-highlighter shared/elixir/code/ regex \b(dbg|__using__|__before_compile__|__after_compile__)\b 0:builtin
add-highlighter shared/elixir/code/ regex \b(def|defp|defmacro|defmacrop|defstruct|defmodule|defimpl|defprotocol|defoverridable|defguard|defguardp|defdelegate)\b 0:keyword
add-highlighter shared/elixir/code/ regex \b(fn|do:?|end|when|case|if|else|unless|var!|for|cond|quote|unquote|receive|with|raise|reraise|try|catch|rescue|after)\b 0:keyword

# Commands
# ‾‾‾‾‾‾‾‾

define-command -hidden elixir-trim-indent %{
    # remove trailing white spaces
    try %{ execute-keys -draft -itersel x s \h+$ <ret> d }
}

define-command -hidden elixir-insert-on-new-line %[
    evaluate-commands -no-hooks -draft -itersel %[
        # copy '#' comment prefix and following white spaces
        try %{ execute-keys -draft k x s ^\h*\K#\h* <ret> y jgi P }
        # wisely add end structure
        # evaluate-commands -save-regs x %[
        #     try %{ execute-keys -draft k x s ^ \h + <ret> \" x y } catch %{ reg x '' }
        #     try %[
        #         evaluate-commands -draft %[
        #             # Check if previous line opens a block
        #             execute-keys -draft kx <a-k>^<c-r>x(.+\bdo$)<ret>
        #             # Check that we do not already have an end for this indent level which is first set via `elixir-indent-on-new-line` hook
        #             execute-keys -draft }i J x <a-K> ^<c-r>x(end|else)[^0-9A-Za-z_!?]<ret>
        #         ]
        #         execute-keys -draft o<c-r>xend<esc> # insert a new line with containing end
        #     ]
        # ]
    ]
]

define-command -hidden elixir-indent-on-new-line %{
    evaluate-commands -draft -itersel %{
        # preserve previous line indent
        try %{ execute-keys -draft <semicolon> K <a-&> }
        # indent after line ending with:
        # try %{ execute-keys -draft k x <a-k> (\bdo|\belse|->)$ <ret> & }
        # filter previous line
        try %{ execute-keys -draft k : elixir-trim-indent <ret> }
        # indent after lines ending with do or ->
        try %{ execute-keys -draft <semicolon> k x <a-k> ^.+(\bdo|->)$ <ret> j <a-gt> }
    }
}

§
