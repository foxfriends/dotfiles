function fish_mode_prompt --description 'Displays the current mode'
    if test "$fish_key_bindings" = "fish_vi_key_bindings"
        or test "$fish_key_bindings" = "fish_hybrid_key_bindings"
        switch $fish_bind_mode
            case default
                set_color -io red
                echo 'def'
            case insert
                set_color -io green
                echo 'ins'
            case replace_one
                set_color -io bryellow
                echo 'rep'
            case visual
                set_color -io magenta
                echo 'vis'
        end
        set_color normal
        echo -n ' '
    end
end
