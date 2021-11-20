evaluate-commands %sh{
    background='rgb:282c34'
    background_hl='rgb:3e4451'
    gutter='rgb:2f383b'
    comment='rgb:545862'
    text='rgb:abb2bf'
    field='rgb:e06c75'
    constant='rgb:d19a66'
    type='rgb:e5c07b'
    string='rgb:98c379'
    builtin='rgb:56b6c2'
    function='rgb:61afef'
    keyword='rgb:c678dd'

    ## code
    echo "
        face global value ${constant}
        face global type ${type}
        face global variable ${field}
        face global identifier ${field}
        face global field ${field}
        face global string ${string}
        face global keyword ${keyword}
        face global operator ${keyword}
        face global attribute ${keyword}
        face global comment ${comment}+i
        face global doc_comment ${comment}+b
        face global meta ${builtin}
        face global builtin ${builtin}
        face global function ${function}
        face global module ${field}+i
    "

    ## markup
    echo "
        face global title ${field}+b
        face global header ${field}+b
        face global bold ${type}+b
        face global italic ${keyword}+i
        face global mono ${string}
        face global block ${builtin}
        face global link ${constant}
        face global bullet ${field}
        face global list ${field}
    "

    ## custom
    echo "
        face global NormalCursor default,${background_hl}
        face global InsertCursor ${background},${text}
    "

    ## builtin
    echo "
        face global Default ${text},${background}
        face global PrimarySelection default,${gutter}
        face global SecondarySelection default,${gutter}+i
        face global PrimaryCursor NormalCursor
        face global PrimaryCursorEol ${background}+f@PrimaryCursor
        face global SecondaryCursor default,${background_hl}+i
        face global SecondaryCursorEol ${background}+f@SecondaryCursor
        face global LineNumbers ${background_hl},${background}
        face global LineNumberCursor ${type},${background}
        face global MenuForeground ${background},${type}+b
        face global MenuBackground ${background},${text}
        face global MenuInfo ${background_hl}
        face global Information ${background},${type}
        face global Error ${background},${field}
        face global StatusLine ${text},${background_hl}
        face global StatusLineMode ${text}
        face global StatusLineInfo ${text}
        face global StatusLineValue ${text}
        face global StatusCursor ${background},${text}
        face global Prompt ${function}
        face global MatchingChar default,${background_hl}
        face global Reference default+u
        face global BufferPadding ${background_hl},${background}
        face global Whitespace ${background_hl}+f
    "

    echo "hook global ModeChange '.*:insert' %{ face global PrimaryCursor @InsertCursor }"
    echo "hook global ModeChange '.*:normal' %{ face global PrimaryCursor @NormalCursor }"

    ## LSP
    echo "
        face global DiagnosticError default+u
        face global DiagnosticWarning default+u
    "

    ## powerline
    echo "
    define-command -hidden powerline-theme-custom %{
        set-option global powerline_color00 '$background'    # fg: bufname
        set-option global powerline_color03 '$type'          # bg: bufname
        set-option global powerline_color02 '$background'    # fg: git
        set-option global powerline_color04 '$string'        # bg: git
        set-option global powerline_color05 '$background'    # fg: position
        set-option global powerline_color01 '$field'         # bg: position
        set-option global powerline_color06 '$background'    # fg: line-column
        set-option global powerline_color09 '$constant'      # bg: line-column
        set-option global powerline_color07 '$text'          # fg: mode-info
        set-option global powerline_color08 '$background_hl' # bg: mode-info
        set-option global powerline_color10 '$background'    # fg: filetype
        set-option global powerline_color11 '$function'      # bg: filetype
        set-option global powerline_color13 '$background'    # fg: client
        set-option global powerline_color12 '$keyword'       # bg: client
        set-option global powerline_color15 '$background'    # fg: session
        set-option global powerline_color14 '$keyword'       # bg: session
        set-option global powerline_color19 '$background'    # fg: unicode
        set-option global powerline_color18 '$field'         # bg: unicode

        declare-option -hidden str powerline_next_bg ${background_hl}
        declare-option -hidden str powerline_base_bg ${background_hl}
    }
    "
}
