""
" Help:
" ----------- | Navigation
" <C-\>       | Show/hide tree view
" g,          | - Open init.vim (this file)
" g'          | - Open manfest file (language dependent)
" gd          | - Go to declaration
" gl          | - Jump to line
" gL          | - Jump to line (any pane)
" <C-s>       | - Jump to search (1 character)
" \w          | - Jump to word (down)
" <Enter>     | - Jump to word
" <F9>        | - Open an embedded terminal
" <C-p>       | - Fuzzy finder open file
" <A-asdf>    | - Change windows
" <A-hjkl>    | - Move fast
" ----------- | Spelling
" <Space>f    | - Fix
" <Space>s    | - Toggle
" <Space>g    | - Mark as ok
" ----------- | Intellisense
" H           | - Hover
" <C-Space>   | - Autocomplete
" <F2>        | - Refactor (Rename)
" ----------- | Git
" gs          | - git status
" ga          | - git add -A
" gc          | - git commit
" gp          | - git push
" +           | - git add %
" -           | - git reset %
" ----------- | Windows
" <C-k>       | Split pane
"      left   | - to the left
"      right  | - to the right
" ----------- | Formatting
" <Space>w    | Trim whitespace
" <Space>a    | Easy align
"         ip= | - align in paragraph on =
" cs          | Change surroundings
"   '"        | - from ' to "
"   []        | - from [ ([] with spaces) to ] ([] with no spaces)
" ys          | Add surroundings
"   iw'       | - ' around word
" ds          | Remove surroundings
"   '         | - ' around
" <C-l>       | Enter Unicode as Latex
" ----------- | Sessions
" ss          | - Save session
" sa          | - Save session as
" sl          | - Load session
" so          | - Open default session
""

set shell=bash

"Install the plugin thing if it isn't installed yet
"note that it only auto-installs the first time. Later modifications must be
"run manually with :PlugInstall
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"Install the plugins
call plug#begin('~/.vim/plugged')
Plug 'joshdick/onedark.vim'                                                          " colour scheme
Plug 'sheerun/vim-polyglot'                                                          " language packs
Plug 'scrooloose/nerdtree'                                                           " tree view
Plug 'scrooloose/nerdcommenter'                                                      " ctrl-slash for comment
Plug 'vim-airline/vim-airline'                                                       " bottom bar
Plug 'vim-airline/vim-airline-themes'                                                " bottom bar colours
Plug 'ctrlpvim/ctrlp.vim'                                                            " CtrlP fuzzy finder
Plug 'junegunn/fzf'                                                                  " idk more fuzzy finder or something
Plug 'junegunn/vim-easy-align'                                                       " auto align stuff
Plug 'junegunn/goyo.vim'                                                             " distraction free writing
Plug 'junegunn/limelight.vim'                                                        " spotlighting
Plug 'jparise/vim-graphql'                                                           " GraphQL syntax highlighting
Plug 'airblade/vim-gitgutter'                                                        " git addition/deletions in the left bar
Plug 'easymotion/vim-easymotion'                                                     " jumping around
Plug 'vim-scripts/sessionman.vim'                                                    " sessions
Plug 'lrvick/Conque-Shell'                                                           " terminal inside Vim
Plug 'tpope/vim-fugitive'                                                            " control git from inside Vim
Plug 'tpope/vim-surround'                                                            " surround things in quotes, etc.
Plug 'kshenoy/vim-signature'                                                         " handles and displays the marks
Plug 'terryma/vim-multiple-cursors'                                                  " multiple cursor support
Plug 'projectfluent/fluent.vim'                                                      " fluent syntax highlighting
Plug 'murarth/ketos', { 'rtp': 'etc/vim' }                                           " ketos syntax highlighting
Plug 'luochen1990/rainbow'                                                           " rainbow parentheses
Plug 'arthurxavierx/vim-unicoder'                                                    " unicode input
Plug 'SidOfc/mkdx'                                                                   " markdown improvements
Plug 'LukeSmithxyz/vimling'                                                          " some other accents/IPA input
Plug 'francoiscabrol/ranger.vim'                                                     " integration with ranger
Plug 'rbgrouleff/bclose.vim'                                                         " required for ranger integration
Plug 'evanleck/vim-svelte'                                                           " svelte syntax highlighting
Plug 'jceb/vim-orgmode'                                                              " emacs org-mode for vim
Plug 'tpope/vim-speeddating'                                                         " better date support for increment
Plug 'idanarye/breeze.vim'                                                           " easymotion for HTML
Plug 'neoclide/coc.nvim', {'branch': 'release'}                                      " coc language client
call plug#end()

" fix the bugs?
set nocompatible      " fixes for weird keybindings
set nobackup
set nowritebackup
set backupcopy=yes    " fixes for file watchers

set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes

" some ergonomics things
let mapleader = " "
inoremap <A-p> <ESC>
noremap <A-h> 10h
noremap <A-j> 10j
noremap <A-k> 10k
noremap <A-l> 10l
noremap zz :w<CR>
inoremap <A-a> <C-o><C-w>h
inoremap <A-s> <C-o><C-w>j
inoremap <A-d> <C-o><C-w>k
inoremap <A-f> <C-o><C-w>l
nnoremap <A-a> <C-w>h
nnoremap <A-s> <C-w>j
nnoremap <A-d> <C-w>k
nnoremap <A-f> <C-w>l

let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key      = '<Leader>n'
let g:multi_cursor_select_all_word_key = '<Leader>N'
let g:multi_cursor_start_key           = '<Leader>gn'
let g:multi_cursor_select_all_key      = '<Leader>gN'
let g:multi_cursor_next_key            = '<Leader><C-n>'
let g:multi_cursor_prev_key            = '<Leader><C-N>'
let g:multi_cursor_skip_key            = '<Leader><A-n>'
let g:multi_cursor_quit_key            = '<Esc>'

" auto indents
filetype plugin indent on
set backspace=2
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
nnoremap <Leader><Tab> :set expandtab!<CR>

" allow mouse controls...
set mouse=a
" show line numbers
set number
" show invisibles
set list
set listchars=tab:»\ ,eol:¬,space:·
" something something idk
set cursorline

" enable colour scheme
set termguicolors
syntax on
set encoding=utf-8
colorscheme onedark

" markdown
let g:polyglot_disabled = ['markdown']
let g:mkdx#settings     = { 'highlight': { 'enable': 1 },
                          \ 'map': { 'prefix': '<leader>', 'enable': 1 },
                          \ 'tokens': { 'bold': '__', 'italic': '*', 'strike': '~', 'list': '*', 'fence': '`', 'header': '#' },
                          \ 'links': { 'external': { 'enable': 1 } },
                          \ 'toc': { 'text': 'Table of Contents', 'update_on_write': 1 } }

nnoremap <leader>mi :call ToggleIPA()<CR>

" rainbow
let g:rainbow_active = 0
nnoremap <Leader>mp :RainbowToggle<CR>

" goyo
nnoremap <Leader>mr :Goyo 100<CR>

" spelling
set spell spelllang=en_ca
nnoremap <Leader>f 1z=
nnoremap <Leader>s :set spell!<CR>
nnoremap <Leader>g zg
set nospell

nnoremap zg zz

"Save with sudo
cmap w!! w !sudo tee > /dev/null %

"Splitting, atom style (ctrl-k [direction])
" insert mode
imap <C-k><left> <C-o>:abo vsp %<CR>
imap <C-k><h <C-o>:abo vsp %<CR>
imap <C-k><right> <C-o>:bel vsp %<CR>
imap <C-k>l <C-o>:bel vsp %<CR>
imap <C-k><up> <C-o>:abo sp %<CR>
imap <C-k>k <C-o>:abo sp %<CR>
imap <C-k><down> <C-o>:bel sp %<CR>
imap <C-k>j <C-o>:bel sp %<CR>
" normal mode
nmap <C-k><left> :abo vsp %<CR>
nmap <C-k><h :abo vsp %<CR>
nmap <C-k><right> :bel vsp %<CR>
nmap <C-k>l :bel vsp %<CR>
nmap <C-k><up> :abo sp %<CR>
nmap <C-k>k :abo sp %<CR>
nmap <C-k><down> :bel sp %<CR>
nmap <C-k>j :bel sp %<CR>

" tabs navigation
nnoremap <Leader>t :tabnew<CR>
nnoremap <Leader><Left> :tabp<CR>
nnoremap <Leader><Right> :tabn<CR>

" buffers navigation
nnoremap gb :ls<CR>:b<Space>

"Open this file (g ,)
nmap g, :n ~/.config/nvim/init.vim<CR>

"Open this file (g ,)
nmap g, :n ~/.config/nvim/init.vim<CR>

"Trim whitespace from end of lines
nnoremap <Leader>w :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

"Git
" `git status` (g s)
nmap <Leader>gs :Gstatus<CR>
" `git commit` (g c)
nmap <Leader>gc :Gcommit<CR>
" `git push` (g p)
nmap <Leader>gp :Gpush<CR>
" `git add -A` (g a)
nmap <Leader>ga :silent !git add -A<CR>
" `git add` this file (+)
nmap + :silent !git add %<CR>
" `git reset` this file (-)
nmap - :silent !git reset %<CR><C-l>
" Set the base for gutter markings
let g:gitgutter_diff_base = 'HEAD'

"Easy motion
let g:EasyMotion_smartcase = 1
"Jump somewhere (Enter)
nmap <Enter> <Plug>(easymotion-bd-w)
"Go to line (g l)
nmap gl <Plug>(easymotion-bd-jk)
"Go to line in any window (g L)
nmap g<S-l> <Plug>(easymotion-overwin-line)
"Go to char in any window (Ctrl-s)
nmap <C-s> <Plug>(easymotion-overwin-f)
imap <C-s> <C-o><Plug>(easymotion-overwin-f)

" EasyAlign
xmap <Leader>a <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)

"Session management.
"Kind of difficult to get right always, but sometimes it is quick and handy
let v:this_session = 'default'
let sessionman_save_on_exit = 1
"Save current open windows (s s)
nmap ss :SessionSave<CR>
"Save current session with name (s a)
nmap sa :SessionSaveAs<CR>
"Open some recent session, good for resuming after closing (s o)
nmap so :SessionOpen default<CR>
"Open a specific named session (s l)
nmap sl :SessionList<CR>

"Language server integration
set hidden

"Tree view (Ctrl-\)
map <C-\> :NERDTreeToggle<CR>

"Commenting
"Toggle comment line/selection (Ctrl-/)
nmap <C-_> <leader>ci
vmap <C-_> <leader>ci
imap <C-_> <C-o><leader>ci

"Airline
"Make sure you install a Powerline version of a font. I suggest Fira Code
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
"Pick a nice colour
let g:airline_theme = 'bubblegum'

"CtrlP Fuzzy finder
"Some directories and stuff to skip. Makes it faster if you skip a lot
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/](\.(git|hg|svn|build)|node_modules|Pods|elm-stuff|target|dist|vendor)$',
    \ 'file': '\v\.(exe|so|dll|DS_store|swp)$',
    \ }
nnoremap <Leader><C-P> :CtrlPClearAllCaches<CR>

"Conque-Shell
"Open a terminal inside of vim (F9)
" nmap <F9> :ConqueTermVSplit bash<CR>
nmap <F9> <Plug>(coc-terminal-toggle)

"Ranger
let g:ranger_map_keys = 0
let g:ranger_replace_netrw = 1
nnoremap <silent><Leader>\ :Ranger<CR>
nnoremap <silent><C-\> :RangerWorkingDirectory<CR>

function! InvertMeaning ()
  normal! "iyiw
  echom @i
  let mappings = {
    \ "true": "false",
    \ "false": "true",
    \ "1": "0",
    \ "0": "1",
    \ "max": "min",
    \ "min": "max",
    \ "<": ">",
    \ ">": "<",
    \ ">=": "<=",
    \ "<=": ">=",
    \ "!=": "==",
    \ "==": "!=",
    \ }
  if has_key(mappings, @i)
    execute "normal! ciw" . mappings[@i]
  endif
endfunction

nnoremap <Leader>i :call InvertMeaning()<CR><Esc>

"coc

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <right> pumvisible() ? "\<C-n>" : "\<right>"
inoremap <expr><left> pumvisible() ? "\<C-p>" : "\<left>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> <Leader>r <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
