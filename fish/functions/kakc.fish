function kakc --description 'Start kak in the most recent existing session'
    set session (kak -l | head -n 1 | tr -d '\n')
    echo $session
    if test -n "$session"
        kak -c $session $argv
    else
        kak $argv
    end
end
