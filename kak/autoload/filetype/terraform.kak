# Detection
hook global BufCreate .*[.](tf|tfvars) %{
    set-option buffer filetype terraform
    set buffer tabstop 2
    set buffer indentwidth 2
    set-option buffer formatcmd 'terraform fmt -'
}

# Initialization
hook global WinSetOption filetype=terraform %{
    require-module terraform
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window terraform-.+
    }

    hook window ModeChange pop:insert:.* -group terraform-trim-indent terraform-trim-indent
    hook window InsertChar \n -group terraform-indent terraform-indent-on-new-line
    hook window InsertChar \{ -group terraform-indent terraform-indent-on-opening-curly-brace
    hook window InsertChar [)}] -group terraform-indent terraform-indent-on-closing
}

hook -group terraform-highlight global WinSetOption filetype=terraform %{
    add-highlighter window/terraform ref terraform
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/terraform }
}

provide-module terraform %§
    add-highlighter shared/terraformstring                    regions
    add-highlighter shared/terraformstring/                       default-region fill string
    add-highlighter shared/terraformstring/interpolation          region -recurse \{ (?<!\$)\$\{   \}  regions
    add-highlighter shared/terraformstring/interpolation/             default-region fill interpolation
    add-highlighter shared/terraformstring/interpolation/content      region -recurse \{ (?<!\$)\$\{\K   (?=\})  ref terraform

    # Highlighters
    add-highlighter shared/terraform    regions
    add-highlighter shared/terraform/       region "^\s*#" "$"              ref comment
    add-highlighter shared/terraform/       region '"'  (?<!\\)(\\\\)*"     ref terraformstring
    add-highlighter shared/terraform/       region -match-capture '<<-?\h*''?(\w+)''?' '^\s*(\w+)$'  ref terraformstring
    add-highlighter shared/terraform/props  default-region group
    add-highlighter shared/terraform/props/     regex \b([a-z_A-Z][\w-]*)\s*(?=\() 1:function
    add-highlighter shared/terraform/props/     regex \b([a-z_A-Z][\w-]*)\s*(?=[{"]) 1:meta
    add-highlighter shared/terraform/props/     regex \b([0-9]+(\.[0-9]+)?)\b     1:value
    add-highlighter shared/terraform/props/     regex \b(false|true|null)\b       1:value
    add-highlighter shared/terraform/props/     regex \b(var|local)\b       1:identifier
    add-highlighter shared/terraform/props/     regex [?:=]            0:keyword

    define-command -hidden terraform-trim-indent %{
        # remove trailing white spaces
        try %{ execute-keys -draft -itersel x s \h+$ <ret> d }
    }

    define-command -hidden terraform-indent-on-new-line %~
        evaluate-commands -draft -itersel %<
            # copy // comments prefix and following white spaces
            try %{ execute-keys -draft k x s ^\h*\K//[!/]?\h* <ret> y gh j P }
            # preserve previous line indent
            try %{ execute-keys -draft <semicolon> K <a-&> }

            # filter previous line
            try %{ execute-keys -draft k : terraform-trim-indent <ret> }
            # indent after lines ending with { or (
            try %[ execute-keys -draft k x <a-k> [{(]\h*$ <ret> j <a-gt> ]
            # indent after lines ending with [{(].+
            # try %< execute-keys -draft [c[({],[)}] <ret> <a-k> L i<ret><esc> <gt> <a-S> <a-&> >
        >
    ~

    define-command -hidden terraform-indent-on-opening-curly-brace %[
        evaluate-commands -draft -itersel %_
            # align indent with opening paren when { is entered on a new line after the closing paren
            try %[ execute-keys -draft h <a-F> ) M <a-k> \A\(.*\)\h*\n\h*\{\z <ret> s \A|.\z <ret> 1<a-&> ]
        _
    ]

    define-command -hidden terraform-indent-on-closing %[
        evaluate-commands -draft -itersel %_
            # align to opening curly brace or paren when alone on a line
            try %< execute-keys -draft <a-h> <a-k> ^\h*[)}]$ <ret> h m <a-S> 1<a-&> >
        _
    ]
§
