# https://github.com/foxfriends/syncat
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

provide-module preview-syncat %{
    require-module detection
    check-cmd syncat
    set-option global previewcmd 'syncat -en'
}
