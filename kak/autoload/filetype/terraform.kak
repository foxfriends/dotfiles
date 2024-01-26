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
}

hook -group terraform-highlight global WinSetOption filetype=terraform %{
    add-highlighter window/terraform ref terraform
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/terraform }
}

provide-module terraform %~
    add-highlighter shared/terraformstring                    regions
    add-highlighter shared/terraformstring/                       default-region fill string
    add-highlighter shared/terraformstring/interpolation          region -recurse \{ \$\{   \}  regions
    add-highlighter shared/terraformstring/interpolation/             default-region fill interpolation
    add-highlighter shared/terraformstring/interpolation/content      region -recurse \{ \$\{\K   (?=\})  ref terraform

    # Highlighters
    add-highlighter shared/terraform    regions
    add-highlighter shared/terraform/       region "^\s*#" "$"              ref comment
    add-highlighter shared/terraform/       region '"'  (?<!\\)(\\\\)*"     ref terraformstring
    add-highlighter shared/terraform/       region -match-capture '<<-?\h*''?(\w+)''?' '^\t*(\w+)$'  ref terraformstring
    add-highlighter shared/terraform/props  default-region group
    add-highlighter shared/terraform/props/     regex \b([a-z_A-Z][\w-]*)\s*(?=\() 1:function
    add-highlighter shared/terraform/props/     regex \b([a-z_A-Z][\w-]*)\s*(?=[{"]) 1:meta
    add-highlighter shared/terraform/props/     regex \b([0-9]+(\.[0-9]+)?)\b     1:value
    add-highlighter shared/terraform/props/     regex \b(false|true|null)\b       1:value
    add-highlighter shared/terraform/props/     regex \b(var|local)\b       1:identifier
    add-highlighter shared/terraform/props/     regex [?:=]            0:keyword
~
