# Tool: repl
# ‾‾‾‾‾‾‾‾‾‾
# runs the selected code in the repl for the current language
#
# Options
# ‾‾‾‾‾‾‾
# runcmd: The command used to run a file.
#     The command receives a path to a copy of the current buffer and is expected to
#     run that code in the current language, printing the output of that program

declare-option -docstring "command to run code" str runcmd
declare-option -docstring "name of the client to show run output in" str runclient
declare-option -docstring "name of the run output buffer" str runbuf '*script output*'

define-command run -docstring 'run the current selection' %{
    evaluate-commands %sh{
        if [ -z "${kak_opt_runcmd}" ]; then
            echo 'fail The `runcmd` option is not set'
            exit 1
        fi

        dir=$(mktemp -d "${TMPDIR:-/tmp}"/kak-run.XXXXXXXX)
        printf '%s\n' "$kak_selection" > "$dir/script"
        mkfifo "$dir/output"
        ( ${kak_opt_runcmd} "${dir}/script" > "$dir/output" 2>&1 & ) > /dev/null 2>&1 < /dev/null
        printf %s\\n "evaluate-commands -try-client '${kak_opt_runclient}' %{
            edit! -fifo '${dir}/output' '${kak_opt_runbuf}'
            hook -always -once buffer BufCloseFifo .* %{ nop %sh{ rm -r $dir } }
        }"
    }
}
