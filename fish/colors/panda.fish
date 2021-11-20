if test "$TERM" = "linux"
  echo -en "\e]P02A2C2D" #black
  echo -en "\e]P831353A" #darkgrey
  echo -en "\e]P1FF2C6D" #darkred
  echo -en "\e]P9FF4B82" #red
  echo -en "\e]P219F9D8" #darkgreen
  echo -en "\e]PA6FE7D2" #green
  echo -en "\e]P3FFB86C" #brown
  echo -en "\e]PBFFCC95" #yellow
  echo -en "\e]P445A9F9" #darkblue
  echo -en "\e]PC6FC1FF" #blue
  echo -en "\e]P5B084EB" #darkmagenta
  echo -en "\e]PDBCAAFE" #magenta
  echo -en "\e]P6FF75B5" #darkcyan (actually pink)
  echo -en "\e]PEFF9AC1" #cyan (actually pink)
  echo -en "\e]P7676B79" #lightgrey
  echo -en "\e]PFE6E6E6" #white
  echo -en '\e[40;1;37m\e[8]'
  clear #for background artifacting
end

set -xg fish_color_autosuggestion brwhite
set -xg fish_color_cancel white
set -xg fish_color_command blue
set -xg fish_color_comment brwhite
set -xg fish_color_cwd green
set -xg fish_color_cwd_root green
set -xg fish_color_end brwhite
set -xg fish_color_error brred
set -xg fish_color_escape brblue
set -xg fish_color_history_current --bold
set -xg fish_color_host purple
set -xg fish_color_match --background=brblue
set -xg fish_color_normal white
set -xg fish_color_operator white
set -xg fish_color_param bryellow
set -xg fish_color_quote green
set -xg fish_color_redirection brblue
set -xg fish_color_search_match yellow
set -xg fish_color_selection 'white'  '--background=brblack'
set -xg fish_color_status red
set -xg fish_color_user yellow
set -xg fish_color_valid_path --underline
set -xg fish_color_vcs cyan
set -xg fish_color_tab bryellow
