#!/usr/bin/env fish

set -x SHELL (status fish-path)
set -q skin; or set -Ux skin onedark
set -x GPG_TTY (tty)
set -x COLORTERM truecolor

function addpath --description "add a directory to the PATH"
  test -d "$argv[1]"; and fish_add_path "$argv[1]"
end

if test -x /opt/homebrew/bin/brew
  # NOTE: Don't use `brew shellenv` because it sets variables nastily.
  # We can just reimplement it manually here but better
  # eval (/opt/homebrew/bin/brew shellenv)

  # These are all the same
  set -gx HOMEBREW_PREFIX "/opt/homebrew"
  set -gx HOMEBREW_CELLAR "/opt/homebrew/Cellar"
  set -gx HOMEBREW_REPOSITORY "/opt/homebrew"
  set -q MANPATH; or set MANPATH ''; set -gx MANPATH "/opt/homebrew/share/man" $MANPATH;
  set -q INFOPATH; or set INFOPATH ''; set -gx INFOPATH "/opt/homebrew/share/info" $INFOPATH;

  # but use custom add path so that homebrew doesn't get top priority.
  addpath "/opt/homebrew/opt/postgresql@15/bin"
  addpath "/opt/homebrew/opt/postgresql@16/bin"
  addpath "/opt/homebrew/sbin"
  addpath "/opt/homebrew/bin"

  # and also this :shrug:
  set -ax LD_LIBRARY_PATH "/opt/homebrew/lib"

  # If we've installed llvm from brew, we need to link up everything.
  if test -d /opt/homebrew/opt/llvm
    addpath "/opt/homebrew/opt/llvm/bin"
    set -agx LDFLAGS "-L/opt/homebrew/opt/llvm/lib/c++ -L/opt/homebrew/opt/llvm/lib/unwind -L/opt/homebrew/opt/llvm/lib -lunwind"
    set -agx CPPFLAGS "-I/opt/homebrew/opt/llvm/include"
  end

  if test -d /opt/homebrew/opt/zstd
    set -agx LDFLAGS "-L/opt/homebrew/opt/zstd/lib"
    set -agx CPPFLAGS "-I/opt/homebrew/opt/zstd/include"
  end

  # Chances are, if LLVM is installed, I'm working with llvm-sys
  if test -d /opt/homebrew/opt/llvm@18
    set -x LLVM_SYS_181_PREFIX /opt/homebrew/opt/llvm@18/
  end
  if test -d /opt/homebrew/opt/llvm@19
    set -x LLVM_SYS_191_PREFIX /opt/homebrew/opt/llvm@19/
  end
  if test -d /opt/homebrew/opt/llvm@21
    set -x LLVM_SYS_211_PREFIX /opt/homebrew/opt/llvm@21/
  end
end

# If not on Mac, LLVM will likely be here
if test -d /usr/lib/llvm-18
  set -x LLVM_SYS_181_PREFIX /usr/lib/llvm-18/
end
if test -d /usr/lib/llvm-19
  set -x LLVM_SYS_191_PREFIX /usr/lib/llvm-19/
end
if test -d /usr/lib/llvm-21
  set -x LLVM_SYS_211_PREFIX /usr/lib/llvm-21/
end

addpath "/opt/local/bin"
addpath "/opt/local/sbin"
addpath "$HOME/go/bin"
addpath "$HOME/.orbstack/bin"
addpath "$HOME/.asdf/shims"
addpath "$HOME/.pyenv/bin"
addpath "$HOME/.pyenv/shims"
addpath "$HOME/.rbenv/bin"
addpath "$HOME/.cargo/bin"
addpath "$HOME/.deno/bin"
addpath "$HOME/.cabal/bin"
addpath "$HOME/.ghcup/bin"
addpath "$HOME/.gem/bin"
addpath "$HOME/.local/bin"
addpath "$HOME/.bin"
addpath "$HOME/.bun/bin"
addpath "$HOME/.rye/shims"
addpath "$HOME/.radicle/bin"

set -x GEM_HOME "$HOME/.gem"
addpath "$GEM_HOME/bin"

set -ax LD_LIBRARY_PATH "/usr/local/lib"

if command -q pipenv
  set -x PIPENV_VENV_IN_PROJECT true
end

if status --is-interactive
  if command -q zoxide
    source (zoxide init fish |psub)
  else if command -q pazi
    source (pazi init fish |psub)
  end
  command -q rbenv; and source (rbenv init -|psub)
  command -q pyenv; and source (pyenv init -|psub)
  # command -q kitty; and source (kitty + complete setup fish |psub)
  command -q diesel; and source (diesel completions fish |psub)
  command -q deno; and source (deno completions fish |psub)
  command -q rustup; and source (rustup completions fish |psub)
  command -q gh; and source (gh completion -s fish |psub)
  command -q kak; and set -x EDITOR (which kak)
  command -q pack; and source (pack completion --shell fish)
  command -q paper; and source (paper --completions fish |psub)
  command -q mise; and source (mise activate fish |psub)
  
  if command -q sk
    set -x JUST_CHOOSER sk
  else if command -q fzf
    set -x JUST_CHOOSER fzf
  end
  
  if command -q tv
    source (tv init fish |psub)
    set -x JUST_CHOOSER tv
  end
  if command -q fnm
    source (fnm completions |psub)
    source (fnm env |psub)
    source (fnm env --use-on-cd |psub)
  end
  if command -q fd
    set -x FZF_DEFAULT_COMMAND 'fd --type f'
    set -x SKIM_DEFAULT_COMMAND "fd --type f -E '*.snap'"
  end
  if command -q bun
    set -x BUN_INSTALL "$HOME/.bun"
  end

  command -q aws aws-mfa-secure; and alias aws="aws-mfa-secure session"

  # replace ls with exa
  if command -q exa
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

# Local additons can be put in additional configuration directories
if set -q fish_user_configs
  for dir in $fish_user_configs
    if test -d "$dir"
      source "$dir/config.fish"
    end
  end
end

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
