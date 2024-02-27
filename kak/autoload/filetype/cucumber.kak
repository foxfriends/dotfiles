# http://cukes.info
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](feature|story) %{
    set-option buffer filetype cucumber
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=cucumber %{
    require-module cucumber

    hook window ModeChange pop:insert:.* -group cucumber-trim-indent cucumber-trim-indent
    hook window InsertChar \n -group cucumber-insert cucumber-insert-on-new-line
    hook window InsertChar \n -group cucumber-indent cucumber-indent-on-new-line

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window cucumber-.+ }
}

hook -group cucumber-load-languages global WinSetOption filetype=cucumber %{
    hook -group cucumber-load-languages window NormalIdle .* cucumber-load-languages
    hook -group cucumber-load-languages window InsertIdle .* cucumber-load-languages
}

hook -group cucumber-highlight global WinSetOption filetype=cucumber %{
    add-highlighter window/cucumber ref cucumber
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/cucumber }
}


provide-module cucumber %{

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/cucumber regions
add-highlighter shared/cucumber/code default-region group
add-highlighter shared/cucumber/language region ^\h*#\h*language: $ group
add-highlighter shared/cucumber/comment  region ^\h*#             $ ref comment

add-highlighter shared/cucumber/language/ fill meta
add-highlighter shared/cucumber/language/ regex \S+$ 0:value

# Spoken languages
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
# https://github.com/cucumber/cucumber/wiki/Spoken-languages
#
# curl --location https://github.com/cucumber/gherkin/raw/master/lib/gherkin/i18n.json
#
# {
#   "en": {
#     "name": "English",
#     "native": "English",
#     "feature": "Feature|Business Need|Ability",
#     "background": "Background",
#     "scenario": "Scenario",
#     "scenario_outline": "Scenario Outline|Scenario Template",
#     "examples": "Examples|Scenarios",
#     "given": "*|Given",
#     "when": "*|When",
#     "then": "*|Then",
#     "and": "*|And",
#     "but": "*|But"
#   },
#   …
# }
#
# jq 'with_entries({ key: .key, value: .value | del(.name) | del(.native) | join("|") })'
#
# {
#   "en": "Feature|Business Need|Ability|Background|Scenario|Scenario Outline|Scenario Template|Examples|Scenarios|*|Given|*|When|*|Then|*|And|*|But",
#   …
# }

add-highlighter shared/cucumber/code/   regex \b(Feature|Business\h+Need|Ability|Background|Scenario|Scenario\h+Outline|Scenario\h+Template|Examples|Scenarios|Given|When|Then|And|But)\b 0:keyword
add-highlighter shared/cucumber/code/   regex <[\w\d]+>                           0:meta
add-highlighter shared/cucumber/string  region %{(?<!')"} (?<!\\)(\\\\)*"    fill string

evaluate-commands %sh{
  languages="
    awk c cabal clojure coffee cpp css cucumber d diff dockerfile fish
    gas go haml haskell html ini java javascript json julia kickstart
    latex lisp lua makefile markdown moon objc perl pug python ragel
    ruby rust sass scala scss sh swift toml tupfile typescript yaml sql
    sml scheme graphql
  "
  for lang in ${languages}; do
    printf 'add-highlighter shared/cucumber/%s_t region -match-capture ^(\\h*)```\\h*%s\\b   ^(\\h*)``` regions\n' "${lang}" "${lang}"
    printf 'add-highlighter shared/cucumber/%s_t/ default-region fill meta\n' "${lang}"
    printf 'add-highlighter shared/cucumber/%s_t/inner region ^\\h*```[^\\n]*\\K (?=```) ref %s\n' "${lang}" "${lang}"

    printf 'add-highlighter shared/cucumber/%s_q region -match-capture %%{^(\\h*)"""\\h*%s\\b}   %%{^(\\h*)"""} regions\n' "${lang}" "${lang}"
    printf 'add-highlighter shared/cucumber/%s_q/ default-region fill meta\n' "${lang}"
    printf 'add-highlighter shared/cucumber/%s_q/inner region %%{^\\h*"""[^\\n]*\\K} %%{(?=""")} ref %s\n' "${lang}" "${lang}"
  done
}

# Commands
# ‾‾‾‾‾‾‾‾

define-command -hidden cucumber-trim-indent %{
    # remove trailing white spaces
    try %{ execute-keys -draft -itersel x s \h+$ <ret> d }
}

define-command -hidden cucumber-insert-on-new-line %{
    evaluate-commands -draft -itersel %{
        # copy '#' comment prefix and following white spaces
        try %{ execute-keys -draft k x s ^\h*\K#\h* <ret> y gh j P }
    }
}

define-command -hidden cucumber-indent-on-new-line %{
    evaluate-commands -draft -itersel %{
        # preserve previous line indent
        try %{ execute-keys -draft <semicolon> K <a-&> }
        # filter previous line
        try %{ execute-keys -draft k : cucumber-trim-indent <ret> }
        # indent after lines containing :
        try %{ execute-keys -draft , k x <a-k> : <ret> j <a-gt> }
    }
}

}

define-command -hidden cucumber-load-languages %{
    evaluate-commands -draft %{ try %{
        execute-keys 'gtGbGls```\h*\K[^\s]+<ret>'
        evaluate-commands -itersel %{ require-module %val{selection} }
    }}
    evaluate-commands -draft %{ try %{
        execute-keys 'gtGbGls"""\h*\K[^\s]+<ret>'
        evaluate-commands -itersel %{ require-module %val{selection} }
    }}
}
