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

  if command -q rad
    set inbox_output (rad inbox)
    if test "$inbox_output" != 'Your inbox is empty.'
      printf ' %s%s 󰯉 %s' (set_color -b yellow) (set_color black) (set_color normal)
    end
  end

  if git rev-parse --is-inside-work-tree > /dev/null 2>&1
    printf ' %s' (set_color $fish_color_vcs)

    set remote_github ""
    set remote_rad ""
    set remote_tangled ""
    set remote_codeberg ""
    set remote_natto ""
    for remote in (git remote)
      set remote_url (git remote show $remote -n | rg 'Fetch URL: (.*)' -or '$1')
      if echo "$remote_url" | rg 'github.com' -q
        set remote_github ' '
      else if echo "$remote_url" | rg 'forgejo.home.eldridge.cam' -q
        set remote_natto ' '
      else if echo "$remote_url" | rg 'rad://' -q
        set remote_rad '󰯉 '
      else if echo "$remote_url" | rg 'codeberg.org' -q
        set remote_codeberg ' '
      else if echo "$remote_url" | rg 'knot.eldridge.cam' -q
        set remote_tangled '󰳆 '
      end
    end

    set sed_pattern 's/\bfoxfriends\b/🦊/'
    if test (uname) = 'Darwin'
      set sed_pattern 's/[[:<:]]foxfriends[[:>:]]/🦊/'
    end

    printf '%s%s%s%s%s %s' \
      $remote_github \
      $remote_rad \
      $remote_tangled \
      $remote_codeberg \
      $remote_natto \
      (git branch | grep \* | cut -d ' ' -f2- | sed $sed_pattern)
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
