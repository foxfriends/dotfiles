function fix --description "Fix everything"
  if not git status > /dev/null 2>&1
    exit 0
  end
  
  if test -f package.json
    git ls-files -m | xargs prettier --write
  end
  
  if test -f Cargo.toml
    cargo fmt
  end
end
