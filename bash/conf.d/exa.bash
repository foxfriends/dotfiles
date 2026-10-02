if check eza; then 
    alias ls='eza'
    alias ll='eza -alg --git'
    alias lt='eza -T'
    alias llt='eza -lT'
    alias l='eza'
elif check exa; then
    alias ls='exa'
    alias ll='exa -alg --git'
    alias lt='exa -T'
    alias llt='exa -lT'
    alias l='exa'
fi
