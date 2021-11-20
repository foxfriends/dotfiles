# other integration modules that need loading
hook -group issues global KakBegin .* %{
    require-module detection
    load-all gh jira
}
