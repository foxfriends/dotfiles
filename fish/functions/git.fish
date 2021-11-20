function c --description 'git fuzzy-checkout'
  git branch | sed 's/^\*//' | string trim | fzf -1 -0 -q "$argv" | xargs git checkout
end
