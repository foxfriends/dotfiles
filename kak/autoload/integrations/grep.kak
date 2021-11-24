# https://man7.org/linux/man-pages/man1/grep.1.html
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module grep-grep %{
    require-module detection
    check-cmd grep

    set-option global grepcmd 'grep -RHn'
}
