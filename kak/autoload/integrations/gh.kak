# https://github.com/cli/cli
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module gh %{
    require-module detection
    check-cmd gh

    define-command gh -docstring 'gh' -params .. %{
        info %sh{ gh $@ }
    }

    ## Not sure how this works yet
    # declare-option -hidden completions gh_issues
    # 
    # define-command gh-autocomplete-issue -hidden %{
    #     evaluate-commands %sh{
    #         header="${kak_cursor_line}.${kak_cursor_column}@${kak_timestamp}"
    #         tab=$(echo "\t")
    #         result=$(gh issue list | cut -f1,3 | sed "s/$tab/|nop|/")
    #         printf "%s\\n" "echo completed"
    #         printf "set-option buffer gh_issues %%{%s\\n%s}\\n" "$header" "$result"
    #     }
    # }
}
