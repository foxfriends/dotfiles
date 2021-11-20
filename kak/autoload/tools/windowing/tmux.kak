provide-module windowing-tmux %{
    require-module tmux
    alias global terminal       tmux-popup
    alias global terminal-popup tmux-popup
    alias global terminal-tab   tmux-new
    alias global terminal-left  tmux-new-left
    alias global terminal-right tmux-new-right
    alias global terminal-above tmux-new-up
    alias global terminal-below tmux-new-down
    alias global focus          tmux-focus
}
