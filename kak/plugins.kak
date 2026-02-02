evaluate-commands %sh{
  # We're assuming the default bundle_path here...
  plugins="$kak_config/bundle"
  mkdir -p "$plugins"
  [ ! -e "$plugins/kak-bundle" ] && \
    git clone -q https://codeberg.org/jdugan6240/kak-bundle "$plugins/kak-bundle"
  printf "%s\n" "source '$plugins/kak-bundle/rc/kak-bundle.kak'"
}

bundle-noload kak-bundle https://codeberg.org/jdugan6240/kak-bundle

bundle kakoune-buffers https://github.com/Delapouite/kakoune-buffers %{
    map global normal ^ q
    map global normal <a-^> Q
    map global normal q b
    map global normal Q B
    map global normal <a-q> <a-b>
    map global normal <a-Q> <a-B>
    map global normal b ': enter-buffers-mode<ret>' -docstring 'buffers'
    map global normal B ': enter-user-mode -lock buffers<ret>' -docstring 'buffers (lock)'
    map global buffers '#' ': edit -scratch "*script output*"<ret>' -docstring '*script output*'
}

bundle smarttab.kak https://github.com/foxfriends/smarttab.kak

hook global ModuleLoaded smarttab %{
    set-option global softtabstop 4
}

hook global WinSetOption filetype=(.*) expandtab
hook global WinSetOption filetype=(makefile|gas) noexpandtab

hook global ModuleLoaded powerline %{
    set-option global powerline_format 'mode_info buffername filetype line_column unicode bettergit client session'
    set-option -add global powerline_themes 'custom'
    powerline-separator curve
    powerline-theme custom

    hook global WinCreate (.*) %{
        powerline-theme custom
        powerline-separator curve
    }
}

bundle powerline.kak https://github.com/andreyorst/powerline.kak %{
    powerline-start
}

bundle kakoune-text-objects https://github.com/delapouite/kakoune-text-objects %{
    map global modes s ':enter-user-mode selectors<ret>' -docstring 'selectors'
    map global insert <a-s> '<esc>:enter-user-mode selectors<ret>' -docstring 'selectors'
    map global normal <a-s> '<esc>:enter-user-mode selectors<ret>' -docstring 'selectors'
    trigger-user-hook plugin-loaded=delapouite/kakoune-text-objects
}

bundle kakoune-mirror https://github.com/delapouite/kakoune-mirror %{
    map global normal "'" ': enter-user-mode -lock mirror<ret>'
    hook global BufSetOption filetype=(markdown|typst) %{
        map buffer mirror * 'a*<esc>i*<esc>H<a-;>' -docstring '*surround*'
        map buffer mirror _ 'a_<esc>i_<esc>H<a-;>' -docstring '_surround_'
    }
}

bundle kakoune-lsp 'git clone -b v19.0.1 https://github.com/kakoune-lsp/kakoune-lsp' %{
    set-option global lsp_diagnostic_line_error_sign '║'
    set-option global lsp_diagnostic_line_warning_sign "⚠"

    define-command ne -docstring 'go to next error/warning from lsp' %{ lsp-find-error --include-warnings }
    define-command pe -docstring 'go to previous error/warning from lsp' %{ lsp-find-error --previous --include-warnings }
    define-command ee -docstring 'go to current error/warning from lsp' %{ lsp-find-error --include-warnings; lsp-find-error --previous --include-warnings }

    hook global WinSetOption filetype=(rust|haskell|literate-haskell|javascript|typescript|html|css|svelte|python|solidity|elixir|hcl|terraform|go|gleam|csharp) %{
        set-option window lsp_auto_highlight_references true
        set-option window lsp_hover_anchor false
        # lsp-auto-hover-enable
        echo -debug "Enabling LSP for %opt{filetype}"
        lsp-enable-window
    }

    hook global KakEnd .* lsp-exit
}

bundle-install-hook kakoune-lsp %{
    cargo install --locked --force --path .
}

bundle kakoune-vertical-selection https://github.com/occivink/kakoune-vertical-selection

bundle shadow.kak https://github.com/ftonneau/shadow.kak %{
    shadow-set csharp \
        conditional "#if" "#endif" nofirst nolast section

    shadow-decorate csharp \
        conditional_border "#(if|else|endif)" sectionborder
}
