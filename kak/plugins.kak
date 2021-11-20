source "%val{config}/plugins/plug.kak/rc/plug.kak"

plug 'kakounedotcom/prelude.kak' %{
    require-module prelude
}

plug 'delapouite/kakoune-buffers' %{
    map global normal ^ q
    map global normal <a-^> Q
    map global normal q b
    map global normal Q B
    map global normal <a-q> <a-b>
    map global normal <a-Q> <a-B>
    map global normal b ': enter-buffers-mode<ret>' -docstring 'buffers'
    map global normal B ': enter-user-mode -lock buffers<ret>' -docstring 'buffers (lock)'
}

plug "andreyorst/powerline.kak" defer powerline %{
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
}

plug "andreyorst/smarttab.kak" defer smarttab %{
    # when `backspace' is pressed, 4 spaces are deleted at once
    set-option global softtabstop 4
} config %{
    hook global WinSetOption filetype=(.*) expandtab
    hook global WinSetOption filetype=(makefile|gas) noexpandtab
}

plug 'occivink/kakoune-vertical-selection'

plug 'delapouite/kakoune-text-objects' %{
    map global user s ': enter-user-mode selectors<ret>' -docstring 'selectors'
}

plug 'delapouite/kakoune-mirror' %{
    map global normal "'" ': enter-user-mode -lock mirror<ret>'
    hook global BufSetOption filetype=markdown %{
        map buffer mirror * 'a*<esc>i*<esc>H<a-;>' -docstring '*surround*'
        map buffer mirror _ 'a_<esc>i_<esc>H<a-;>' -docstring '_surround_'
    }
}

plug "ul/kak-lsp" do %{
    cargo install --locked --force --path .
} noload config %{
    eval %sh{kak-lsp --config "${kak_config}/kak-lsp.toml" --kakoune -s $kak_session}

    hook global WinSetOption filetype=(rust|haskell|literate-haskell|javascript|typescript|html) %{
        lsp-enable-window
    }
    set-option global lsp_diagnostic_line_warning_sign "⚠"
}

plug 'https://gitlab.com/Screwtapello/kakoune-cargo'
