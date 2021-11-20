function school --description 'SSH to the school'
    if test (count $argv) = 1
        set machine $argv[1]
        env TERM=xterm-256color ssh "ckeldrid@ubuntu1804-$machine.student.cs.uwaterloo.ca"
    else
        env TERM=xterm-256color ssh ckeldrid@linux.student.cs.uwaterloo.ca
    end
end
