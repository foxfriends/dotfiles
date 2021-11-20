if test "$TERM" = "linux"
  echo -en "\e]P0383A42" #black
  echo -en "\e]P8A0A1A7" #darkgrey
  echo -en "\e]P1E45649" #darkred
  echo -en "\e]P9B33022" #red
  echo -en "\e]P250A14F" #darkgreen
  echo -en "\e]PA50A14F" #green
  echo -en "\e]P3C18401" #brown
  echo -en "\e]PBE08026" #yellow
  echo -en "\e]P4248BE0" #darkblue
  echo -en "\e]PC375670" #blue
  echo -en "\e]P5C678DD" #darkmagenta
  echo -en "\e]PDA626A4" #magenta
  echo -en "\e]P60997B4" #darkcyan
  echo -en "\e]PE0997B4" #cyan
  echo -en "\e]P7D4D4D4" #lightgrey
  echo -en "\e]PFFAFAFA" #white
  echo -en '\e[47;1;30m\e[8]'
  clear #for background artifacting
end

set -xg fish_color_autosuggestion brblack
set -xg fish_color_cancel black
set -xg fish_color_command blue
set -xg fish_color_comment brblack
set -xg fish_color_cwd green
set -xg fish_color_cwd_root green
set -xg fish_color_end brblack
set -xg fish_color_error brred
set -xg fish_color_escape brblue
set -xg fish_color_history_current --bold
set -xg fish_color_host purple
set -xg fish_color_match --background=brblue
set -xg fish_color_normal black
set -xg fish_color_operator black
set -xg fish_color_param bryellow
set -xg fish_color_quote green
set -xg fish_color_redirection brblue
set -xg fish_color_search_match yellow
set -xg fish_color_selection 'black'  '--background=brwhite'
set -xg fish_color_status red
set -xg fish_color_user yellow
set -xg fish_color_valid_path --underline
set -xg fish_color_vcs bryellow
set -xg fish_color_tab cyan
