declare-option -docstring "modules that provide a fuzzyfind command" \
    str-list fuzzyfind_providers "fuzzyfind-broot" "fuzzyfind-tv" "fuzzyfind-sk" "fuzzyfind-fzf"

hook -group fuzzyfind global KakBegin .* %{
    require-module detection
    load-first %opt{fuzzyfind_providers}
}
