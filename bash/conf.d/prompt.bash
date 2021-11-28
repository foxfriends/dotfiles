#!/bin/bash

_prompt() {
    local last_status=$?
    local red='\033[0;31m'
    PS1=''

    if [ $last_status -ne 0 ]; then
        PS1+=$(printf '%s[%s] ' $red $last_status)
    fi

    local yellow='\033[0;33m'
    PS1+=$(printf '%s%s ' $yellow "$(whoami)")

    local purple='\033[0;35m'
    PS1+=$(printf '%s%s' $purple "$(hostname)")

    local orange='\033[0;93m'
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        PS1+=$(printf ' %s %s' $orange "$(git branch | grep \* | cut -d ' ' -f2-)")
    fi

    local green='\033[0;32m'
    PS1+=$(printf ' %s%s' $green "$(pwd | sed "s#^$HOME#~#")")

    local normal='\033[0m'
    if [ $(id -u) -eq 0 ]; then
        PS1+=$(printf '%s# ' $normal)
    else
        PS1+=$(printf '%s> ' $normal)
    fi
}

PROMPT_COMMAND=_prompt
