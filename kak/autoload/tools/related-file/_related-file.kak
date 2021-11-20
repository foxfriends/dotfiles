# Tool: related-file
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
# for cycling through files related to the one in the current buffer.

declare-option -docstring 'command that returns the name of the next related file' \
    str relatedfilecmd

hook -group related-file global KakBegin .* %{
    define-command open-related -docstring "opens the next related file" %{
        edit -existing %sh{$kak_opt_relatedfilecmd $kak_buffile}
    }

    define-command open-related-new -docstring "opens the next related file" %{
        edit %sh{$kak_opt_relatedfilecmd $kak_buffile}
    }
}

