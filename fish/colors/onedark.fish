if test "$TERM" = "linux"
  echo -en "\e]P0282C34" #black
  echo -en "\e]P83E4452" #darkgrey
  echo -en "\e]P1E06C75" #darkred
  echo -en "\e]P9BE5046" #red
  echo -en "\e]P298C378" #darkgreen
  echo -en "\e]PA98C379" #green
  echo -en "\e]P3E5C07B" #brown
  echo -en "\e]PBD19A66" #yellow
  echo -en "\e]P461AFEF" #darkblue
  echo -en "\e]PC61AFEF" #blue
  echo -en "\e]P5C678DD" #darkmagenta
  echo -en "\e]PDC678DD" #magenta
  echo -en "\e]P656B6C2" #darkcyan
  echo -en "\e]PE56B6C2" #cyan
  echo -en "\e]P7ABB2BF" #lightgrey
  echo -en "\e]PF5C6370" #white
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
