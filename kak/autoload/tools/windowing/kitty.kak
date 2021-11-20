provide-module windowing-kitty %{
    require-module kitty
    alias global terminal       kitty-new
    alias global terminal-tab   kitty-new-tab
    alias global focus          kitty-focus
    alias global terminal-left  kitty-new-horizontal
    alias global terminal-right kitty-new-horizontal
    alias global terminal-above kitty-new-vertical
    alias global terminal-below kitty-new-vertical
}
