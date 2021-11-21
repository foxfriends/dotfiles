# https://github.com/lotabout/skim
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module sk %{
    require-module detection
    check-cmd sk

    define-command -docstring "use sk to find and open a file" sk %{
        evaluate-result "run () { cd '%sh{pwd}'; file=$(%opt{findcmd} | sk --preview ""%opt{previewcmd} {}""); if [ -n $file ]; then printf 'edit! -existing %%s\\n' ""$file""; fi; } && run "
    }
}
