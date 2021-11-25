declare-user-mode windowing
map global windowing h ":terminal-left %sh{which kak} -c %val{session} <ret>" -docstring "split left"
map global windowing l ":terminal-right %sh{which kak} -c %val{session} <ret>" -docstring "split right"
map global windowing k ":terminal-above %sh{which kak} -c %val{session} <ret>" -docstring "split above"
map global windowing j ":terminal-below %sh{which kak} -c %val{session} <ret>" -docstring "split below"
