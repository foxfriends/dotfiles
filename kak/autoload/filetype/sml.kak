# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*\.sml? %{
    set-option buffer filetype sml
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=sml %{
    require-module sml
    set-option window static_words %opt{sml_static_words}
}

hook -group sml-highlight global WinSetOption filetype=sml %{
    add-highlighter window/sml ref sml
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/sml }
}

provide-module sml %{
    # Highlighters
    # ‾‾‾‾‾‾‾‾‾‾‾‾

    add-highlighter shared/sml regions
    add-highlighter shared/sml/code default-region group
    add-highlighter shared/sml/string region (?<!')" (?<!\\)(\\\\)*" fill string
    add-highlighter shared/sml/comment region \Q(* \Q*) ref comment
    add-highlighter shared/sml/code/char regex %{\B'([^'\\]|(\\[\\"'nrtb])|(\\\d{3})|(\\x[a-fA-F0-9]{2})|(\\o[0-7]{3}))'\B} 0:value
    add-highlighter shared/sml/code/ regex "(datatype|abstype)\s+(\w+)" 1:meta
    add-highlighter shared/sml/code/ regex "\b(string|int|char|bool|list)\b" 1:meta
    add-highlighter shared/sml/code/ regex "fun\s+(\w+)" 1:function
    add-highlighter shared/sml/code/ regex "val\s+(\w+)" 1:field
    add-highlighter shared/sml/code/ regex "\b[A-Z][a-zA-Z0-9_]*\b" 0:type
    add-highlighter shared/sml/code/ regex "(\*|\bof\b)\s*([a-zA-Z0-9_]+)" 1:keyword 2:builtin
    add-highlighter shared/sml/code/ regex "\|" 0:keyword
    add-highlighter shared/sml/code/ regex "!|:=|=|=>|>|<|\+|-|\^|:>|:" 0:keyword
    add-highlighter shared/sml/code/ regex "\b[0-9]+(\.[0-9]+)?\b" 0:value
    add-highlighter shared/sml/code/ regex "\(\)" 0:value

    # Macro
    # ‾‾‾‾‾

    evaluate-commands %sh{
      keywords="and|as|asr|assert|begin|class|constraint|do|done|downto|datatype|else|end|exception|external|false"
      keywords="${keywords}|for|fun|function|functor|if|in|include|inherit|initializer|land|lazy|let|lor"
      keywords="${keywords}|lsl|lsr|lxor|match|method|mod|module|mutable|new|nonrec|object|of|open|or"
      keywords="${keywords}|private|rec|sig|struct|then|to|true|try|type|val|virtual|when|while|with"
      keywords="${keywords}|before|after|orelse|andalso|raise|handle|fn|abstype|local|structure|signature|eqtype|sharing"

      printf %s\\n "declare-option str-list sml_static_words ${keywords}" | tr '|' ' '

      printf %s "
        add-highlighter shared/sml/code/ regex \b(${keywords})\b 0:keyword
      "
    }
}
