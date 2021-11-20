# Tool: fuzzyfinder
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
# fuzzyfinder finds files by fuzzy matching. Sometimes it provides even more features

declare-option -docstring "modules that implement fuzzyfinders" \
    str-list fuzzyfinder_modules "broot" "fzf"
declare-option -docstring "modules that provide a primary fuzzyfinder" \
    str-list fuzzyfinder_providers "fuzzyfinder-broot" "fuzzyfinder-fzf"

hook -group fuzzyfind global KakBegin .* %{
    require-module detection
    load-all %opt{fuzzyfinder_modules}
    load-first %opt{fuzzyfinder_providers}
}
