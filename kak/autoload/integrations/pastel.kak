# https://github.com/sharkdp/pastel/
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module pastel %{
    require-module detection
    check-cmd pastel

    declare-user-mode pastel
    map global pastel f '|pastel format ' -docstring 'color format'
}
