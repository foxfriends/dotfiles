# Tool: related-file
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
# for cycling through files related to the one in the current buffer.

declare-option -docstring 'command that returns the name of the next related file' \
    str relatedfilecmd

define-command open-related -docstring "opens the next related file" %{
    evaluate-commands %sh{
        if [ -z "${kak_opt_relatedfilecmd}" ]; then
            echo 'fail The `relatedfilecmd` option is not set'
            exit 1
        fi
    }
    edit -existing %sh{$kak_opt_relatedfilecmd $kak_buffile}
}

define-command open-related-new -docstring "opens the next related file" %{
    evaluate-commands %sh{
        if [ -z "${kak_opt_relatedfilecmd}" ]; then
            echo 'fail The `relatedfilecmd` option is not set'
            exit 1
        fi
    }
    edit %sh{$kak_opt_relatedfilecmd $kak_buffile}
}
