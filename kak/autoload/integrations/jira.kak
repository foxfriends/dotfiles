provide-module jira %{
    require-module detection
    check-cmd jira

    define-command jira -docstring 'jira' -params .. %{
        info %sh{ jira $@ }
    }
}
