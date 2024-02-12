source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug-chain "andreyorst/plug.kak" noload \
plug 'kakounedotcom/prelude.kak' %{
    require-module prelude
} plug 'delapouite/kakoune-buffers' %{
    map global normal ^ q
    map global normal <a-^> Q
    map global normal q b
    map global normal Q B
    map global normal <a-q> <a-b>
    map global normal <a-Q> <a-B>
    map global normal b ': enter-buffers-mode<ret>' -docstring 'buffers'
    map global normal B ': enter-user-mode -lock buffers<ret>' -docstring 'buffers (lock)'
} plug "andreyorst/powerline.kak" demand powerline %{
    set-option global powerline_format 'mode_info buffername filetype line_column unicode bettergit client session'
    set-option -add global powerline_themes 'custom'
    powerline-separator curve
    powerline-theme custom
    hook global WinCreate (.*) %{
        powerline-theme custom
        powerline-separator curve
    }
} config %{
    powerline-start
} plug "foxfriends/smarttab.kak" defer smarttab %{
    set-option global softtabstop 4
} config %{
    hook global WinSetOption filetype=(.*) expandtab
    hook global WinSetOption filetype=(makefile|gas) noexpandtab
} plug 'delapouite/kakoune-text-objects' %{
    map global modes s ':enter-user-mode selectors<ret>' -docstring 'selectors'
    map global insert <a-s> '<esc>:enter-user-mode selectors<ret>' -docstring 'selectors'
    map global normal <a-s> '<esc>:enter-user-mode selectors<ret>' -docstring 'selectors'
    trigger-user-hook plugin-loaded=delapouite/kakoune-text-objects
} plug 'delapouite/kakoune-mirror' %{
    map global normal "'" ': enter-user-mode -lock mirror<ret>'
    hook global BufSetOption filetype=(markdown|typst) %{
        map buffer mirror * 'a*<esc>i*<esc>H<a-;>' -docstring '*surround*'
        map buffer mirror _ 'a_<esc>i_<esc>H<a-;>' -docstring '_surround_'
    }
} plug "kak-lsp/kak-lsp" do %{
    cargo install --locked --force --path .
} config %{
    set-option global lsp_diagnostic_line_warning_sign "⚠"
    define-command lsp-restart -docstring 'restart lsp server' %{ lsp-stop; lsp-start }
    hook global WinSetOption filetype=(rust|haskell|literate-haskell|javascript|typescript|html|css|svelte|python|solidity|elixir|hcl|terraform|go) %{
        echo -debug "Enabling LSP for %opt{filetype}"
        lsp-enable-window
    }
    hook global KakEnd .* lsp-exit
} \
plug 'https://gitlab.com/Screwtapello/kakoune-cargo' \
plug 'occivink/kakoune-vertical-selection'
