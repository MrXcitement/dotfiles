" vim:fdm=marker:
"
" .vimrc -- Vim Configuration File.
"
" Mike Barker <mike@thebarkers.com>
"
" Get the running OS {{{
" functions to check what os vim is running on
function! GetRunningOS()
    if has('win32') || has('win64') && &shellcmdflag =~ '/'
        return 'win'
    elseif has('unix')
        if system('uname') =~ 'Darwin'
            return 'mac'
        else
            return 'unix'
        endif
    else
        return '?'
    endif
endfunction

function! IsWin()
    return GetRunningOS() =~ 'win'
endfunction

function! IsMac()
    return GetRunningOS() =~ 'mac'
endfunction

function! IsUnix()
    return GetRunningOS() =~ 'unix'
endfunction

let vim_path = IsWin() ? expand("$HOME/vimfiles") : expand("$HOME/.vim")
" }}}

" vim-plug -- Minimalist Vim Plugin Manager {{{
" Install vim-plug if not found
let vim_plug_path = vim_path . '/autoload/plug.vim'
if empty(glob(vim_plug_path))
  silent exec "!curl --create-dirs -fLo " . vim_plug_path .
    \ " https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
endif

" Add plugins
if !empty(glob(vim_plug_path))

    call plug#begin()

    " General plugins...
    Plug 'tpope/vim-surround'
    Plug 'farmergreg/vim-lastplace'
    Plug 'editorconfig/editorconfig-vim'

    " UI plugins...
    Plug 'sonph/onehalf', { 'rtp': 'vim' }
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    set laststatus=2
    " Enable the list of buffers
    let g:airline#extensions#tabline#enabled = 1
    " Show just the filename
    let g:airline#extensions#tabline#fnamemod = ':t'
    " Show powerline seperators
    let g:airline_powerline_fonts = 1
    Plug 'xolox/vim-misc'
    Plug 'xolox/vim-colorscheme-switcher'
    Plug 'MrXcitement/vim-colorscheme-manager'
    if !exists('g:colorscheme_switcher_exclude')
        let g:colorscheme_switcher_exclude = []
    endif
    if has("gui_running")
        " Keep gui colorscheme seperate from cui/term colorscheme
        let g:colorscheme_manager_file = vim_path . '/.gcolorscheme'
    endif
    " Developer plugins...
    Plug 'tpope/vim-commentary'
    Plug 'ervandew/supertab'
    if executable('git')
        Plug 'airblade/vim-gitgutter'
        if IsWin()
            let g:gitgutter_grep = ''
            let g:gitgutter_async = 0
        endif
        Plug 'tpope/vim-fugitive'
    endif
    Plug 'mattn/webapi-vim'
    Plug 'mattn/gist-vim'
    Plug 'nelstrom/vim-markdown-folding'

    " DevOps plugins...
    if executable('vagrant')
        Plug 'hashivim/vim-vagrant'
    endif
    if executable('ansible')
        Plug 'pearofducks/ansible-vim'
    endif

    " Powershell support
    if executable('pwsh') || executable('powershell')
        Plug 'PProvost/vim-ps1'
    endif

    " Python plugins
    if executable('python') || executable('python3')
        if executable('flake8')
            Plug 'nvie/vim-flake8'
        endif
        Plug 'tmhedberg/simpylfold'
    endif

    " Rust plugins
    if executable('rustc')
        Plug 'rust-lang/rust.vim'
        Plug 'racer-rust/vim-racer'
    endif

    " Ruby plugins
    if executable('ruby')
        Plug 'vim-ruby/vim-ruby'
    endif

    " Swift plugins
    if executable('swift')
        Plug 'keith/swift.vim'
    endif

    " Initialize plugin system
    call plug#end()
    " NOTE: Automatically executes:
    " `filetype plugin indent on` and `syntax enable`.  
    " You can revert the settings after the call like so:
    "   filetype indent off   " Disable file-type-specific indentation
    "   syntax off            " Disable syntax highlighting

endif
" }}}

" Editor settings {{{
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set colorcolumn=80
if &ttytype != "win32"
    set cursorline  " Highlight the current line, except in win console
endif
set encoding=utf-8  " handle Unicode files
set history=50      " keep 50 lines of command line history
set nocompatible    " be iMproved, required by vundle
set nofoldenable    " Do not fold when opening files.
set nowrap          " Whitespace
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set showmatch       " Set viewing matched braces, brackets and parens
" }}}
" Spelling settings {{{
set spelllang=en
set spellfile="/Users/mike/.vim/spell/en.utf-8.add"
" }}}
" Completion {{{
set omnifunc=syntaxcomplete#Complete    " omni complete all
set completeopt=menuone,longest,preview
" }}}
" Show line numbers {{{
" - relative numbers with current line number
set number          " display line numbers
set relativenumber  " display relative number from current line
" }}}
" Searching {{{
set hlsearch
set incsearch
set ignorecase
set smartcase
" }}}
" Indentation {{{
" at http://vimcasts.org/episodes/tabs-and-spaces/
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
" }}}
" Autocomands {{{
" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        autocmd!
        " For all text files set 'textwidth' to 80 characters.
        autocmd FileType text setlocal textwidth=80
    augroup end     " end of vimrcEx augroup
   
    " Run PlugInstall if there are missing plugins
    augroup vimPlugMissing
        autocmd!
        autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \|    PlugInstall --sync | source $MYVIMRC
        \| endif
    augroup end
    " Fixup the Omnicompletion popup menu colors
    augroup customOmnicompletionPopup
        autocmd!
        autocmd ColorScheme * highlight Pmenu ctermbg=Grey ctermfg=Black guibg=Grey guifg=Black
        autocmd ColorScheme * highlight PmenuSel ctermbg=DarkGrey ctermfg=Grey guibg=Black guifg=Grey
    augroup end " end customOmnicompletionPopup
endif " has("autocmd")
" }}}
" UI Settings, fonts, colors, etc. {{{
syntax enable
if has("gui_running")
    if has("gui_gtk")
        set guifont=FiraCode\ Nerd\ Font\ Light\ 10
        if &guifont =~? "Nerd"
            set guiligatures=!\"#$%&()*+-./:<=>?@[]^_{\|~
        endif

    elseif has("gui_win32")
        set guifont=FiraCode_Nerd_Font_Mono_Light:h12,Consolas:h12
        if &guifont =~? 'Nerd'
            set renderoptions=type:directx
        endif

    elseif has('gui_mac') || has('gui_macvim')
        set guifont=FiraCodeNFM-Light:h12,Monaco:h12
        if &guifont =~? 'NFM'
            set macligatures
        endif

    elseif has("x11")
        set guifont=-*-courier-medium-r-normal-*-*-180-*-*-m-*-*
    endif

    "" Disable the toolbar in gui windows...
    set guioptions-=T

else
    " Change cursor shape between insert and normal mode in iTerm2.app
    if $TERM_PROGRAM =~ "iTerm"
        let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
        let &t_SR = "\<Esc>]50;CursorShape=2\x7"
        let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
    else
        " Cursor Shapes for different modes
        let &t_SI = "\<Esc>[5 q"  "Insert Mode: Blinking vertical bar
        let &t_SR = "\<Esc>[3 q"  "Replace Mode: Blinking underscore
        let &t_EI = "\<Esc>[1 q"  "Normal Mode: Blinking block
    endif
    " If the terminal supports 24 bit (256) colors, set the termguicolors to
    " use in vim.
    if has("vcon")
        set termguicolors
    endif
endif
" }}}
" Change <leader> from \ to <space> {{{
let mapleader=" "
" }}}
" remap - <leader>s toggle spell checking on and off {{{
nnoremap <silent> <leader>s :set spell!<CR>
" }}}
" remap - <leader>l toggles viewing whitespace {{{
" http://vimcasts.org/episodes/show-invisibles/
" Changed from TextMate symbols to standard ASCII so that the
" whitespace characters are visible no mater what font is intalled.
set listchars=tab:]-,trail:_,extends:>,precedes:<,nbsp:~,eol:$
nnoremap <leader>l :set list!<CR>
" }}}
" remap - <leader>n turn on/off line number {{{
" http://dancingpenguinsoflight.com/2009/02/python-and-vim-make-your-own-ide/
nnoremap <leader>n :set nonumber!<CR>:set foldcolumn=0<CR>
" }}}
" remap - <leader>v/V to edit/reload vimrc {{{
" http://www.oreillynet.com/onlamp/blog/2006/08/make_your_vimrc_trivial_to_upd_1.html
" <leader>v brings up my .vimrc
" <leader>V reloads it -- making all changes active (have to save first)
nnoremap <silent> <leader>v :e $MYVIMRC<CR>
nnoremap <silent> <leader>V :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'reloaded' $MYVIMRC"<CR>
" }}}
" remap - window movement shortcuts {{{
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>
" }}}
" remap - remove arrow key mapping {{{
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
" }}}
" Function OpenURI {{{
" Open a web-browser with the URL in the current line
" http://vim.wikia.com/wiki/Open_a_web-browser_with_the_URL_in_the_current_line
" 2013-04-05 MRB - Modified to handle Apple's native vim as well as MacVim
" by moving the system check under has('unix') and then testing the uname
" value.
" 2015-06-22 MRB - Refactor out opening the URI into OpenFile() so that
" it can be used to open the current file in the default app for the
" file type being edited. i.e. open the current html file in the default
" browser.
function! OpenURI()
    let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;:"]*')
    if s:uri != ""
        call OpenFile(s:uri)
    else
        echohl WarningMsg
        echom "No URI found in current line."
        echohl None
    endif
endfunction
" }}}
" Function OpenFile {{{
" Open a file or uri
function! OpenFile(f)
    let s:file=a:f
    let s:cmd=""
    if has("win32")
        let s:cmd = ":silent !start \"" . s:file . "\""
    elseif has("unix")
        let os=substitute(system('uname'), '\n', '', '')
        if os == 'Darwin' || os == 'Mac'
            let s:cmd = ":silent !open \"" . s:file . "\""
        else
            let s:cmd = ":silent !xdg-open \"" . s:file . "\""
        endif
    endif
    exec s:cmd
    redraw!
    echom s:cmd
endfunction

nnoremap <Leader>w :call OpenURI()<CR>
nnoremap <leader>W :update<CR>:call OpenFile(expand('%:p'))<CR>
" }}}
