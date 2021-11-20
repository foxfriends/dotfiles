function wol --description 'Wake on LAN by name'
    set host $argv[1]

    switch "$host"
    case middle-cat
        wakeonlan 00:D8:61:9C:83:27
    case '*'
        echo "unknown host $host"
        return 1
    end
end
