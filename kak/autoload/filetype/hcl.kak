# Detection
hook global BufCreate .*[.](tf|tfvars|hcl) %{
    set-option buffer filetype hcl
}

# Initialization
hook global WinSetOption filetype=hcl %{
    require-module hcl
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window hcl-.+
    }
}

hook -group hcl-highlight global WinSetOption filetype=hcl %{
    add-highlighter window/hcl ref hcl
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/hcl }
}

provide-module hcl %~
    add-highlighter shared/hclstring                    regions
    add-highlighter shared/hclstring/                       default-region fill string
    add-highlighter shared/hclstring/interpolation          region -recurse \{ \$\{   \}  regions
    add-highlighter shared/hclstring/interpolation/             default-region fill interpolation
    add-highlighter shared/hclstring/interpolation/content      region -recurse \{ \$\{\K   (?=\})  ref hcl

    # Highlighters
    add-highlighter shared/hcl    regions
    add-highlighter shared/hcl/       region "^\s*#" "$"              ref comment
    add-highlighter shared/hcl/       region '"'  (?<!\\)(\\\\)*"     ref hclstring
    add-highlighter shared/hcl/       region -match-capture '<<-?\h*''?(\w+)''?' '^\t*(\w+)$'  ref hclstring
    add-highlighter shared/hcl/props  default-region group
    add-highlighter shared/hcl/props/     regex \b([\w-.]+)\s*(?=[=:])    1:identifier
    add-highlighter shared/hcl/props/     regex \b([a-z_A-Z][\w-]*)\s*(?=\() 1:function
    add-highlighter shared/hcl/props/     regex \b([a-z_A-Z][\w-]*)\s*(?=[{"]) 1:meta
    add-highlighter shared/hcl/props/     regex \b([0-9]+(\.[0-9]+)?)\b     1:value
    add-highlighter shared/hcl/props/     regex \b(false|true)\b            1:value
    add-highlighter shared/hcl/props/     regex [?:=]            0:keyword
~
