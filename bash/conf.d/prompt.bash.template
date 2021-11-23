prompt() {
    red='\033[0;31m'

    last_status=$?
    if [ $last_status != 0 ]; then
        printf '%s[%s] ' $red $last_status
    fi

    yellow='\033[0;33m'
    printf '%s%s ' $yellow "$(whoami)"

    purple='\033[0;35m'
    printf '%s%s' $purple "$(hostname)"

    orange='\033[0;93m'
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        printf ' %s %s' $orange "$(git branch | grep \* | cut -d ' ' -f2-)"
    fi

    green='\033[0;32m'
    printf ' %s%s' $green "$(pwd)"

    normal='\033[0m'
    if [ $(id -u) -eq 0 ]; then
        printf '%s# ' $normal
    else
        printf '%s> ' $normal
    fi
}

PS1="$(prompt)"
