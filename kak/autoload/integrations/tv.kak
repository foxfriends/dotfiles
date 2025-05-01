# https://github.com/alexpasmantier/television
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module tv %{
    require-module detection
    check-cmd tv

    define-command -docstring "use tv to find and open a file" tv %{
        evaluate-result "run() { ""%val{config}/scripts/tv"" ""$1"" '%sh{pwd}' ; } && run"
    }
}

provide-module fuzzyfind-tv %{
    require-module tv
    alias global fuzzyfind tv
}

hook -group tv global KakBegin .* %{
    require-module tv
}
