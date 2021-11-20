function config --description 'Manage configs from my config repo'
    set config_dir "$HOME/.config/conflist/"
    if test ! -d "$config_dir"
        git clone https://github.com/foxfriends/config.git "$config_dir"
    end

    set config_spec "$config_dir/spec.txt"
    set cmd $argv[1]
    set program $argv[2]
    set platform (uname)

    set config_line (grep "$program" "$config_spec")

    if test -z "$config_line"
        echo "Unknown program $program"
        return 1
    end

    switch "$platform"
    case Darwin
        set config_location (echo $config_line | cut -d : -f 3)
        if test -z "$config_location"
            set config_location (echo $config_line | cut -d : -f 2)
        end
    case Linux
        set config_location (echo $config_line | cut -d : -f 2)
    case '*'
        echo "Unsupported platform $platform"
        return 1
    end

    set config_location (string trim "$config_location")
    set config_location "$HOME/$config_location"

    switch "$cmd"
    case where
        echo "$config_location"
    case install
        git clone git@github.com:foxfriends/config.git -b "$program" "$config_location" --recursive
    case hinstall
        git clone https://github.com/foxfriends/config.git -b "$program" "$config_location" --recursive
    case update
        pushd "$config_location"
        git pull
        popd
    case '*'
        echo "Unsupported command $cmd"
        return 1
    end
end
