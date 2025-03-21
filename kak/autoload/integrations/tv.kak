# https://github.com/alexpasmantier/television
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module tv %{
    require-module detection
    check-cmd tv

    define-command -docstring "use tv to find and open a file" tv %{
        evaluate-result "run () { cd '%sh{pwd}'; file=$(%opt{findcmd} | tv --preview ""%opt{previewcmd} {}""); if [ -n ""$file"" ]; then printf 'edit! -existing ""%%s""' ""$file"" > $1; fi; } && run"
    }
}

provide-module fuzzyfind-tv %{
    require-module tv
    alias global fuzzyfind tv
}

hook -group tv global KakBegin .* %{
    require-module tv
}
