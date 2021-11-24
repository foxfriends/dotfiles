# Tools
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
# Commands implemented by calling out to external tools and interpreting the
# results somehow.
#
# Supported tools:
# *   copy
# *   filebrowser
# *   find
# *   format
# *   fuzzyfinder
# *   grep
# *   lint
# *   preview
# *   terminal
# *   windowing

declare-option -docstring "name of the client to perform tools actions in" \
    str workclient
