#! /usr/bin/env fish

set -q skin; or set -Ux skin onedark

function addpath --description "add a directory to the PATH"
  test -d "$argv[1]"; and set -ag fish_user_paths "$argv[1]"
end

addpath "$HOME/.bin"
addpath "$HOME/.cargo/bin"
addpath "$HOME/.local/bin"
addpath "$HOME/.deno/bin"
addpath "$HOME/.cabal/bin"
addpath "$HOME/.ghcup/bin"
addpath "$HOME/.rbenv/bin"
addpath "$HOME/.pyenv/bin"
addpath "$HOME/.gem/bin"

set -x GEM_HOME "$HOME/.gem"
set -a LD_LIBRARY_PATH "/usr/local/lib"

if status --is-interactive
  reskin $skin
  command -q pazi; and source (pazi init fish |psub)
  command -q rbenv; and source (rbenv init -|psub)
  command -q pyenv; and source (pyenv init -|psub)
  command -q kitty; and source (kitty + complete setup fish |psub)
  command -q diesel; and source (diesel completions fish |psub)
  command -q deno; and source (deno completions fish |psub)
  command -q rustup; and source (rustup completions fish |psub)
  command -q gh; and source (gh completion -s fish |psub)
  if command -q fnm
    source (fnm completions |psub)
    source (fnm env |psub)
  end

  command -q aws aws-mfa-secure; and alias aws="aws-mfa-secure session"

  # replace ls with exa
  if command -q exa >/dev/null
    alias ls='exa'
    alias ll='exa -alg --git'
    alias lt='exa -T'
    alias llt='exa -lT'
    alias l='exa'
  end

  # enable colors in grep by default
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  
  command -q lesspipe; and eval (env SHELL=/bin/sh lesspipe)
end

# Local additons can be put in ~/.config.fish
test -f "$HOME/.config.fish"; and source "$HOME/.config.fish"

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
