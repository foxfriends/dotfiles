# https://github.com/sharkdp/pastel/
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module pastel %{
    require-module detection
    check-cmd pastel

    declare-user-mode pastel
    map global pastel f '|pastel format' -docstring 'format'
    map global pastel h '|pastel format hex<ret>' -docstring 'to hex'
    map global pastel r '|pastel format rgb<ret>' -docstring 'to rgb'
}
