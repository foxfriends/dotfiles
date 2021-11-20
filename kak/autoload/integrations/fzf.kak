# https://github.com/junegunn/fzf
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module fzf %{
    require-module detection
    check-cmd fzf

    define-command -docstring "use fzf to find and open a file" fzf %{
        evaluate-result "run () { cd '%sh{pwd}'; file=$(%opt{findcmd} | fzf --preview ""%opt{previewcmd} {}""); if [ -n $file ]; then printf 'edit! -existing %%s\\n' ""$file""; fi; } && run "
    }
}
