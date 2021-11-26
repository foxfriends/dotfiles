hook global User plugin-loaded=delapouite/kakoune-text-objects %{
    map global selectors v ':vertical-selection-down<ret>' -docstring 'vertical (down)'
    map global selectors V ':vertical-selection-up-and-down<ret>' -docstring 'vertical (both)'
    map global selectors <a-v> ':vertical-selection-up<ret>' -docstring 'vertical (up)'
}
