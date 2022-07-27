declare-option -docstring "modules which implement a grep provider" \
    str-list grep_providers 'grep-rg' 'grep-grep'

hook -group grep global KakBegin .* %{
    require-module detection
    load-first %opt{grep_providers}
}

declare-option -docstring "name of the client to show grep results in" str grepclient
declare-option -docstring "name of grep buffer" str grepbuf '*grep*'
declare-option -docstring "command to perform searching in files" \
    str grepcmd

declare-option -hidden int grep_current_line 0

define-command -params .. -file-completion -docstring 'grep' grep %{
    evaluate-commands %sh{
        if [ $# -eq 0 ]; then
            set -- "${kak_selection}"
        fi

        output=$(mktemp -d "${TMPDIR:-/tmp}"/kak-grep.XXXXXXXX)/fifo
        mkfifo "${output}"
        ( ${kak_opt_grepcmd} "$@" | tr -d '\r' > "${output}" 2>&1 & ) > /dev/null 2>&1 < /dev/null

        printf %s\\n "evaluate-commands -try-client '${kak_opt_grepclient}' %{
            edit! -fifo '${output}' '${kak_opt_grepbuf}'
            set-option buffer filetype grep
            set-option buffer grep_current_line 0
            hook -always -once buffer BufCloseFifo .* %{ nop %sh{ rm -r $(dirname '${output}') } }
        }"
    }
}

hook -group grep-highlight global WinSetOption filetype=grep %{
    add-highlighter window/grep group
    add-highlighter window/grep/ regex "^((?:\w:)?[^:\n]+):(\d+):(\d+)?" 1:cyan 2:green 3:green
    add-highlighter window/grep/ line %{%opt{grep_current_line}} default+b
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/grep }
}

hook global WinSetOption filetype=grep %{
    hook buffer -group grep-hooks NormalKey <ret> grep-jump
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks buffer grep-hooks }
}

define-command -hidden grep-jump %{
    evaluate-commands %{ # use evaluate-commands to ensure jumps are collapsed
        try %{
            execute-keys 'xs^((?:\w:)?[^:]+):(\d+):(\d+)?<ret>'
            set-option buffer grep_current_line %val{cursor_line}
            evaluate-commands -try-client %opt{workclient} -verbatim -- edit -existing %reg{1} %reg{2} %reg{3}
            try %{ focus %opt{workclient} }
        }
    }
}

define-command grep-next-match -docstring 'Jump to the next grep match' %{
    evaluate-commands -try-client %opt{workclient} %{
        buffer %opt{grepbuf}
        # First jump to end of buffer so that if grep_current_line == 0
        # 0g<a-l> will be a no-op and we'll jump to the first result.
        # Yeah, thats ugly...
        execute-keys "ge %opt{grep_current_line}g<a-l> /^[^:]+:\d+:<ret>"
        grep-jump
    }
    try %{
        evaluate-commands -client %opt{grepclient} %{
            buffer %opt{grepbuf}
            execute-keys gg %opt{grep_current_line}g
        }
    }
}

define-command grep-previous-match -docstring 'Jump to the previous grep match' %{
    evaluate-commands -try-client %opt{workclient} %{
        buffer %opt{grepbuf}
        # See comment in grep-next-match
        execute-keys "ge %opt{grep_current_line}g<a-h> <a-/>^[^:]+:\d+:<ret>"
        grep-jump
    }
    try %{
        evaluate-commands -client %opt{grepclient} %{
            buffer %opt{grepbuf}
            execute-keys gg %opt{grep_current_line}g
        }
    }
}
