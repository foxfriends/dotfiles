function icon --description 'Print an icon from Nerd Fonts by name'
    set pack $argv[1]
    set name $argv[2]
    set var i_{$pack}_{$name}
    bash -c "source \"$HOME/.config/fish/scripts/nerd-fonts/i_$pack.sh\"; echo \"\$$var\""
end
