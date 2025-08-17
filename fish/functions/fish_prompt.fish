function fish_prompt --description 'Write out the prompt'
  set last_status $status
  if test $last_status != '0'
    printf '%s[%s] ' \
      (set_color $fish_color_status) \
      "$last_status"
  end


  printf '%s%s ' \
    (set_color $fish_color_user) \
    (whoami)

  if test -n "$TAB"
    printf '%s%s' \
      (set_color $fish_color_tab) \
      "$TAB"
  end

  printf '%s%s' \
    (set_color $fish_color_host) \
    (prompt_hostname)

  if git rev-parse --is-inside-work-tree > /dev/null 2>&1
    printf ' %s %s' \
      (set_color $fish_color_vcs) \
      (git branch | grep \* | cut -d ' ' -f2- | sed 's/^foxfriends/🦊/')
  end

  if command -q rad
    set radicle (rad .)
    if test $status -eq 0
      printf ' %s󰯉 ' (set_color $fish_color_vcs)
    end
  end

  if test (id -u) -eq 0
    printf ' %s%s%s# ' \
      (set_color $fish_color_cwd_root) \
      (prompt_pwd) \
      (set_color normal)
  else
    printf ' %s%s%s> ' \
      (set_color $fish_color_cwd) \
      (prompt_pwd) \
      (set_color normal)
  end
end
