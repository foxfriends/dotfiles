if [ "$TERM" = "linux" ]; then
  echo -en "\e]P0282c34" # black
  echo -en "\e]P83e4452" # light black
  echo -en "\e]P1e06c75" # red
  echo -en "\e]P9be5046" # light red
  echo -en "\e]P298c378" # green
  echo -en "\e]PA98c379" # light green
  echo -en "\e]P3e5c07b" # yellow
  echo -en "\e]PBd19a66" # light yellow
  echo -en "\e]P461afef" # blue
  echo -en "\e]PC61afef" # light blue
  echo -en "\e]P5c678dd" # magenta
  echo -en "\e]PDc678dd" # light magenta
  echo -en "\e]P656b6c2" # cyan
  echo -en "\e]PE56b6c2" # light cyan
  echo -en "\e]P7abb2bf" # white
  echo -en "\e]PF5c6370" # light white
  echo -en '\e[40;1;37m\e[8]'
  clear # for background artifacting
fi
