function reskin --description 'Change the colour schemes of all the things that need to be changed'
    set -Ux skin $argv[1]
    echo $skin > "$HOME/.config/fish/skin"

    if test "$TERM" = "xterm-kitty"
        kitty @ set-colors -a -c ~/.config/kitty/colors/$skin.conf
    end

    source ~/.config/fish/colors/$skin.fish
    set -gx syncat_active_style $skin

    if test -L "$HOME/.gitconfig"
        cat "$HOME/.config/git/.gitconfig.$skin" > "$HOME/.config/git/.gitconfig.current"
    end

    if test -d "$HOME/.config/broot/"
        rm -f "$HOME/.config/broot/conf.toml" "$HOME/.config/broot/conf-kak.toml"
        cat "$HOME/.config/broot/conf.base.toml" "$HOME/.config/broot/colors.$skin.toml" > "$HOME/.config/broot/conf.toml"
        cat "$HOME/.config/broot/conf-kak.base.toml" "$HOME/.config/broot/colors.$skin.toml" > "$HOME/.config/broot/conf-kak.toml"
    end
end
