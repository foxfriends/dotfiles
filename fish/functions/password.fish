function password --description "Get password from bitwarden"
  if command -q wl-copy
    set copy wl-copy
  else if command -q pbcopy
    set copy pbcopy
  else
    echo "No copy command"
    exit 1
  end

  if ! bw unlock --check > /dev/null 2>&1
    set -xg BW_SESSION (bw unlock --raw)
  end

  tv bw | tr -d '\n' | $copy
end
