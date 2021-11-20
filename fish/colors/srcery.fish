if test "$TERM" = "linux"
  echo -en "\e]P01c1b19" #black
  echo -en "\e]P8918175" #darkgrey
  echo -en "\e]P1ef2f27" #darkred
  echo -en "\e]P9f75341" #red
  echo -en "\e]P2519f50" #darkgreen
  echo -en "\e]PA98bc37" #green
  echo -en "\e]P3fbb829" #brown
  echo -en "\e]PBfed06e" #yellow
  echo -en "\e]P42c78bf" #darkblue
  echo -en "\e]PC68a8e4" #blue
  echo -en "\e]P5e02c6d" #darkmagenta
  echo -en "\e]PDff5c8f" #magenta
  echo -en "\e]P60aaeb3" #darkcyan
  echo -en "\e]PE53fde9" #cyan
  echo -en "\e]P7d0bfa1" #lightgrey
  echo -en "\e]PFfce8c3" #white
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
set -xg fish_color_vcs bryellow
set -xg fish_color_tab cyan
