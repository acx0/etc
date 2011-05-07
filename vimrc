" ---> Sam's vimrc
" ---> 11/05/07

" Notes:
"   ~ filetype specific functions and settings are placed in ~/.vim/ftplugin/<ft>.vim
"   ~ mappings and functions are placed next to their related settings

" ---> Startup {{{
" prevents vim from emulating vi's bugs and limitations
set nocompatible    " enabled when (g)vimrc is found

" setup vundle to manage all other plugins
filetype off    " temporarily disabled (required); enabled below
set runtimepath+=$HOME/.vim/vundle.git  " add vundle to runtimepath
call vundle#rc()
" }}}

" ---> User interface {{{
" easier to reach than \
let mapleader = ","
" easier to reach than Esc or Ctrl-[
imap jk <Esc>

set backspace=start,indent,eol  " make backspace work like 'normal' text editors

" --history
set history=500 " history of commands and searches
set undolevels=500  " changes to be remembered

" --interface appearence
syntax on   " enable syntax highlighting and allow custom highlighting
set title   " set title to filename and modification status
set number  " show line numbers
set ruler   " always show current position
set showcmd " show the command being typed
set showmode    " show current mode (insert, visual, etc.)
set wildmenu    " enhanced command-line completion
set laststatus=2    " always show status line
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o    " filetypes to ignore in file operations

" useful, but can be slow at times
"set cursorline  " highlight current line
"set cursorcolumn    " highlight current column

" --searching
set ignorecase  " ignore case when searching
set smartcase   " case sensitive only when capital letter in expression
set hlsearch    " highlight search terms
set incsearch   " show matches as they are found

" toggle hlsearch and show current value
nmap <Space> :set hlsearch! hlsearch?<CR>

" --feedback
set showmatch   " show matching braces when text indicator is over them
set matchtime=2 " length of time for 'showmatch'

" --redrawing / warnings
set lazyredraw  " don't redraw screen when executing macros
set noerrorbells    " no sound on errors
set novisualbell    " no screen flash on errors

" --insert completion
set completeopt-=preview    " disable 'preview' for insert mode completion

" --spell checking
set spelllang=en_ca " set region to Canadian English

" toggle spell checking and show current value
" z-= on highlighted word gives correction suggestions
nmap <Leader>ss :setlocal spell! spell?<CR>

" --visual theme and appearence
set background=dark

" colorscheme modification
let g:molokai_original = 1  " lighter background in gVim
let g:solarized_termcolors = 256    " use degraded colors in terminal
let g:zenburn_high_Contrast = 1 " darker colors

if has("gui_running")   " gVim specific
    " font setup
    " set according to system
    if has("unix")
        set guifont=Terminus\ 9
        "set guifont=Monospace\ 11
    elseif has("win32")
        set guifont=ter-112n:h9
        "set guifont=Lucida_Console:h9:cANSI
    endif

    if has("unix")
        colorscheme neverland
    elseif has("win32")
        colorscheme neverland-nobold
    endif

    " gVim interface modification
    set guioptions-=m   " remove menu bar
    set guioptions-=T   " remove toolbar
    set guioptions-=r   " remove right scrollbar
    set guioptions-=R
    set guioptions-=l   " remove left scrollbar
    set guioptions-=L
    set guioptions-=b   " remove bottom scrollbar

    " toggle menu bar and toolbar, respectively
    nmap <C-F1> :call ToggleMenuBar()<CR>
    nmap <C-F2> :call ToggleToolbar()<CR>

    function! ToggleMenuBar()
        if &guioptions =~# "m"
            set guioptions-=m
        else
            set guioptions+=m
        endif
    endfunction

    function! ToggleToolbar()
        if &guioptions =~# "T"
            set guioptions-=T
        else
            set guioptions+=T
        endif
    endfunction
else    " terminal vim specific
    if &term == "xterm" || &term == "rxvt-256color" || &term == "screen-bce"
        set t_Co=256    " use 256 colours
        colorscheme neverland
    else
        colorscheme desert
    endif
endif

" --navigation
set scrolloff=5 " scrolling starts 5 lines before window border

" swap functionality of ' and ` since ' is easier to reach
nnoremap ' `
nnoremap ` '

"prevent jumping over wrapped lines
nnoremap <silent> j gj
nnoremap <silent> k gk

" redraw screen so search terms are centered
nnoremap n nzz
nnoremap N Nzz

" easier window navigation
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" --screen management
" window split shortcuts
nmap <Leader>swh :topleft vnew<CR>
nmap <Leader>swl :botright vnew<CR>
nmap <Leader>swk :topleft new<CR>
nmap <Leader>swj :botright new<CR>

nmap <Leader>sh :leftabove vnew<CR>
nmap <Leader>sl :rightbelow vnew<CR>
nmap <Leader>sk :leftabove new<CR>
nmap <Leader>sj :rightbelow new<CR>

" tab creation shortcuts
nmap <Leader>tt :tabs<CR>
nmap <Leader>tn :tabnew<CR>
nmap <Leader>te :tabedit
nmap <Leader>tc :tabclose<CR>
nmap <Leader>tm :tabmove

" auto-expand path to parent of current file; for windows, (v)splits, and tabs
nmap <Leader>ew :edit <C-R>=expand("%:p:h") . "/" <CR>
nmap <Leader>es :split <C-R>=expand("%:p:h") . "/" <CR>
nmap <Leader>ev :vsplit <C-R>=expand("%:p:h") . "/" <CR>
nmap <Leader>et :tabedit <C-R>=expand("%:p:h") . "/" <CR>

" --mouse input
" toggle mouse support; when enabled, mouse selection goes into visual mode
nmap <F12> :call ToggleMouse()<CR>

function! ToggleMouse()
    if !exists("s:old_mouse")
        let s:old_mouse = "a"
    endif

    if &mouse == ""
        let &mouse = s:old_mouse
        echo "Mouse is for Vim (" . &mouse . ")"
    else
        let s:old_mouse = &mouse
        let &mouse = ""
        echo "Mouse is for terminal"
    endif
endfunction
" }}}

" ---> File settings {{{
" --filetype detection
filetype plugin indent on   " let vim detect filetype and load appropriate scripts

" --backup / swap
" multiple combinations for backups, see ':h backup-table'
"set nobackup   " won't leave additional files after vim is closed
"set nowritebackup  " keeps backup file while editing, deleted after
"set noswapfile " keeps everything in memory

" --buffer management
set hidden  " allow buffer to be changed without writing to disk
set autoread    " update file when externally modified
"set autochdir   " change to directory of active buffer

" cd into directory of active buffer and display it
nmap <Leader>cd :lcd %:p:h<CR> <Bar> :pwd<CR>

" --indenting
set fileformats=unix,dos,mac    " try recognizing line endings in this order
set tabstop=4   " width of a tab character in spaces
set softtabstop=4   " defines number of spaces for when adding/removing tabs
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab   " use spaces instead of tab characters; to insert real tab, use <C-v><Tab>
set cindent " automatic indenting; see ':h C-indenting' for comparison

" toggle expandtab and show current value
nmap <Leader>xt :set expandtab! expandtab?<CR>

" set tabstop, softtabstop, and shiftwidth to the same value
nmap <Leader>st :call SetTab()<CR>

function! SetTab()
    let l:new_tab_size = input("set tabstop = softtabstop = shiftwidth = ")

    if l:new_tab_size > 0
        let &l:tabstop = l:new_tab_size
        let &l:softtabstop = l:new_tab_size
        let &l:shiftwidth = l:new_tab_size
    endif

    call SummarizeTabs()
endfunction

function! SummarizeTabs()
    try
        echohl ModeMsg
        echon "tabstop=" . &l:tabstop
        echon " softtabstop=" . &l:softtabstop
        echon " shiftwidth=" . &l:shiftwidth

        if &l:expandtab
            echon " expandtab"
        else
            echon " noexpandtab"
        endif
    finally
        echohl None
    endtry
endfunction

" --copying / pasting
" allow vim commands to copy to system clipboard (*)
" for X11:
"   + is the clipboard register (Ctrl-{c,v})
"   * is the selection register (middle click, Shift-Insert)
if v:version >= 703
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif

" set paste to prevent unexpected code formatting when pasting text
" toggle paste and show current value
nnoremap <Leader>p :set paste! paste?<CR>
"set pastetoggle=<Leader>p

" --file / text manipulation functions
" quickly edit/source vimrc
nmap <Leader>er :edit $MYVIMRC<CR>
nmap <Leader>sr :source $MYVIMRC<CR>

" remove trailing whitespace
nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>

function! Preserve(command)
    " save last search, and cursor position
    let search = @/
    let line = line(".")
    let column = col(".")

    execute a:command
    " restore previous search history, and cursor position
    let @/ = search
    call cursor(line, column)
endfunction

" write to root-owned file when running as non-root by piping through tee using sudo
cmap w!! write !sudo tee % > /dev/null

" append modeline after last line in buffer
" use substitute() instead of printf() to handle "%%s" modeline in LaTeX files
nnoremap <Leader>ml :call AppendModeline()<CR>

function! AppendModeline()
    let l:modeline = printf(" vim: set ts=%d sts=%d sw=%d ft=%s %s :",
                \ &tabstop, &softtabstop, &shiftwidth, &filetype, &expandtab ? "et" : "noet")
    let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
    call append(line("$"), "")
    call append(line("$"), l:modeline)
endfunction

if has("unix")
    " make doc, odt, pdf, and rtf readable (linux only)
    augroup doctypes
        autocmd!
        autocmd BufReadPost *.doc silent %!antiword "%"
        autocmd BufReadPost *.odt,*.odp silent %!odt2txt "%"
        autocmd BufReadPost *.pdf silent %!pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w 78
        autocmd BufReadPost *.rtf silent %!unrtf --text "%"
    augroup end
endif
" }}}

" ---> Plugin configuration {{{
" --plugins
Bundle "bufkill.vim"
Bundle "Conque-Shell"
Bundle "godlygeek/csapprox"
Bundle "javacomplete"
Bundle "Lokaltog/vim-easymotion"
Bundle "msanders/snipmate.vim"
Bundle "nathanaelkane/vim-indent-guides"
Bundle "scrooloose/nerdcommenter"
Bundle "scrooloose/nerdtree"
Bundle "taglist.vim"
Bundle "tpope/vim-surround"
Bundle "VimCoder.jar"
Bundle "Vim-JDE"

" --plugin settings
" --The-NERD-tree
" quickly open NERDTree
nmap <F2> :call OpenNERDTree()<CR>

function! OpenNERDTree()
    if has("unix")
        NERDTreeToggle
    elseif has("win32")
        NERDTree $HOME
    endif
endfunction

" --snipMate
" use custom snippets
let g:snippets_dir = "~/.vim/snippets/"

" --taglist.vim
let g:Tlist_Use_Right_Window = 1

" toggle taglist plugin
nmap <Leader><F2> :TlistToggle<CR>

" --Indent-Guides
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_enable_on_vim_startup = 1

if !has("gui_running")
    let g:indent_guides_auto_colors = 0

    augroup indent_guides_custom
        autocmd!
        " custom colors for indent guide lines
        " light grey
        autocmd VimEnter,Colorscheme * highlight IndentGuidesEven ctermbg=236
        " dark grey
        autocmd VimEnter,Colorscheme * highlight IndentGuidesOdd ctermbg=235
    augroup end
endif
" }}}

" ---> Configuration variables {{{
" compiler to use for custom C ftplugin
let g:CC = "clang"
" }}}

" vim: set ts=4 sts=4 sw=4 ft=vim et :
