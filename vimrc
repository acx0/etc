" ================================================
" => Sam's vimrc
" => 11/05/02
" ================================================

" ================================================
" Sections:
"
"   ~ General
"   ~ User interface
"   ~ Insert mode related
"   ~ Normal mode related
"   ~ Visual mode related
"   ~ Command mode related
"   ~ Plugin setup
"   ~ File settings and management
"
"   ~ Configuration variables
"
" ================================================

" ================================================
" General
" ================================================
" prevents vim from emulating the original vi's bugs and limitations
set nocompatible    " enabled when (g)vimrc is found
set history=500
set undolevels=500
let g:mapleader = ","

" quickly edit/source vimrc
nmap <Leader>er :edit $MYVIMRC<CR>
nmap <Leader>sr :source $MYVIMRC<CR>


" ================================================
" User interface
" ================================================
set title   " set title to filename
set showmode    " show current mode (insert, visual, etc)
set number  " show line numbers
set showcmd " show the command being typed
set ruler   " always show current position
set scrolloff=5 " scrolling starts 5 lines before window border
set wildmenu    " enhanced command-line completion
set laststatus=2    " always show status line
syntax on   " enable syntax highlighting and allow custom highlighting

set background=dark

if has("gui_running")
    " set font according to system
    if has("unix")
        set gfn=Terminus\ 9
        "set gfn=Monospace\ 11
    elseif has("win32")
        set gfn=ter-112n:h9
        "set gfn=Lucida_Console:h9:cANSI
    endif

    " toggle menu bar and toolbar, respectively
    nnoremap <C-F1> :call ToggleMenuBar()<CR>
    nnoremap <C-F2> :call ToggleToolbar()<CR>

    function! ToggleMenuBar()
        if &guioptions =~# "m"
            set guioptions-=m
        else
            set go+=m
        endif
    endfunction

    function! ToggleToolbar()
        if &guioptions =~# "T"
            set guioptions-=T
        else
            set guioptions+=T
        endif
    endfunction

    let g:molokai_original = 1  " lighter background for molokai colourscheme

    if has("unix")
        colorscheme neverland
    elseif has("win32")
        colorscheme neverland-nobold
    endif

    set guioptions-=m   " remove menu bar
    set guioptions-=T   " remove toolbar
    set guioptions-=r   " remove right scrollbar
    set guioptions-=R
    set guioptions-=l   " remove left scrollbar
    set guioptions-=L
    set guioptions-=b   " remove bottom scrollbar
else
    if &term == "xterm" || &term == "rxvt-256color" || &term == "screen-bce"
        set t_Co=256    " use 256 colours
        colorscheme neverland
    else
        colorscheme desert
    endif
endif


" ================================================
" Insert mode related
" ================================================
inoremap jk <Esc>
set backspace=start,indent,eol  " make backspace work like 'normal' text editors
set completeopt-=preview    " disable 'preview' for insert mode completion


" ================================================
" Normal mode related
" ================================================
set ignorecase  " ignore case when searching
set smartcase   " case sensitive only when capital letter in expression
set hlsearch    " highlight search terms
set incsearch   " show matches as they are found
set showmatch   " show matching braces when text indicator is over them
set matchtime=2 " length of time for 'showmatch'
set lazyredraw  " don't redraw screen when executing macros
set noerrorbells    " no sound on errors
set novisualbell    " no screen flash on errors

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
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" useful, but can be slow at times
"set cursorline
"set cursorcolumn

" allow vim commands to copy to system clipboard (*)
" for X11:
"   + is the clipboard register (ctrl-{c,v})
"   * is the selection register (middle click, shift-insert)
set clipboard=unnamed

" prevent unexpected code formatting when pasting text, and show status of 'paste'
nnoremap <Leader>p :set invpaste paste?<CR>
set pastetoggle=<Leader>p

" toggle hlsearch
nmap <Space> :set hlsearch!<CR>

" pressing ,ss will toggle spell checking, z-= on word for correction suggestions
map <Leader>ss :setlocal spell!<CR>

" set region to Canadian English
set spelllang=en_ca


" ================================================
" Visual mode related
" ================================================
map <F12> :call ToggleMouse()<CR>

function! ToggleMouse()
    if !exists("s:oldMouse")
        let s:oldMouse = "a"
    endif

    if &mouse == ""
        let &mouse = s:oldMouse
        echo "Mouse is for Vim (" . &mouse . ")"
    else
        let s:oldMouse = &mouse
        let &mouse = ""
        echo "Mouse is for terminal"
    endif
endfunction


" ================================================
" Command mode related
" ================================================
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
map <Leader>tt :tabs<CR>
map <Leader>tn :tabnew<CR>
map <Leader>te :tabedit
map <Leader>tc :tabclose<CR>
map <Leader>tm :tabmove

" auto-expand path to parent of current file; for windows, (v)splits, and tabs
map <Leader>ew :edit <C-R>=expand("%:p:h") . "/" <CR>
map <Leader>es :split <C-R>=expand("%:p:h") . "/" <CR>
map <Leader>ev :vsplit <C-R>=expand("%:p:h") . "/" <CR>
map <Leader>et :tabedit <C-R>=expand("%:p:h") . "/" <CR>


" ================================================
" Plugin setup
" ================================================
" setup vundle to manage all other plugins
filetype off    " temporarily disable; required (enabled below)
set runtimepath+=~/.vim/vundle.git/
call vundle#rc()

" vim-scripts repos
Bundle "bufkill.vim"
Bundle "Conque-Shell"
Bundle "CSApprox"
Bundle "EasyMotion"
Bundle "Indent-Guides"
Bundle "javacomplete"
Bundle "The-NERD-Commenter"
Bundle "The-NERD-tree"
Bundle "snipMate"
Bundle "surround.vim"
Bundle "taglist.vim"
Bundle "VimCoder.jar"
Bundle "Vim-JDE"

" plugin specific settings

" =======================
" The-NERD-tree
" =======================
" quickly open NERDTree
map <F2> :call OpenNERDTree()<CR>

function! OpenNERDTree()
    if has("unix")
        NERDTreeToggle
    elseif has("win32")
        NERDTree $HOME
    endif
endfunction

" =======================
" snipMate
" =======================
" use custom snippets
let g:snippets_dir = "~/.vim/snippets/"

" =======================
" taglist.vim
" =======================
let g:Tlist_Use_Right_Window = 1

" toggle taglist plugin
map <Leader><F2> :TlistToggle<CR>

" =======================
" Indent-Guides
" =======================
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_enable_on_vim_startup = 1

if !has("gui_running")
    let g:indent_guides_auto_colors = 0

    augroup indent_guides_custom
        autocmd!
        " light grey
        autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=236
        " dark grey
        autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=235
    augroup end
endif

" =======================
" javacomplete
" =======================
augroup java
    autocmd!
    " support for java omnicomplete using javacomplete plugin
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
augroup end


" ================================================
" File settings and management
" ================================================
" multiple permutations for backups, see ':h backup-table'
"set nobackup   " won't leave additional files after vim is closed
"set nowritebackup  " keeps backup file while editing, deleted after
"set noswapfile " keeps everything in memory
set hidden  " allow buffer to be changed without writing to disk
set autoread    " update file when externally modified
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o

set fileformats=unix,dos,mac    " support all three, in this order
set tabstop=4   " width of a tab character in spaces
set softtabstop=4   " defines number of spaces for when adding/removing tabs
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab   " use spaces instead of tab characters
" to insert real tab, use <C-v><Tab>

filetype plugin indent on   " let vim detect filetype and load appropriate scripts
set cindent " automatic indenting; see ':h C-indenting' for comparison

" toggle expandtab
nmap <Leader>xt :set expandtab!<CR>

" write to root-owned file when running as non-root by piping through tee using sudo
cmap w!! write !sudo tee % > /dev/null

" set tabstop, softtabstop, and shiftwidth to the same value
map <Leader>st :call SetTab()<CR>

function! SetTab()
    let l:newTabSize = input("set tabstop = softtabstop = shiftwidth = ")

    if l:newTabSize > 0
        let &l:softtabstop = l:newTabSize
        let &l:tabstop = l:newTabSize
        let &l:shiftwidth = l:newTabSize
    endif

    call SummarizeTabs()
endfunction

function! SummarizeTabs()
    try
        echohl ModeMsg
        echon "tabstop=".&l:tabstop
        echon " shiftwidth=".&l:shiftwidth
        echon " softtabstop=".&l:softtabstop

        if &l:expandtab
            echon " expandtab"
        else
            echon " noexpandtab"
        endif
    finally
        echohl None
    endtry
endfunction

" append modeline after last line in buffer
" use substitute() instead of printf() to handle '%%s' modeline in LaTeX files
nnoremap <Leader>ml :call AppendModeline()<CR>

function! AppendModeline()
    let l:modeline = printf(" vim: set ts=%d sw=%d sts=%d %s :", &tabstop, &shiftwidth, &softtabstop, &expandtab ? "et" : "noet")
    let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
    call append(line("$"), "")
    call append(line("$"), l:modeline)
endfunction

" remove trailing whitespace
nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>

function! Preserve(command)
    " save last search, and cursor position
    let _s = @/
    let l = line(".")
    let c = col(".")

    execute a:command
    " restore previous search history, and cursor position
    let @/ = _s
    call cursor(l, c)
endfunction

if has("unix")
    " make doc, odt, pdf, and rtf readable (linux only)
    augroup doctypes
        autocmd!
        autocmd BufReadPost *.doc silent %!antiword "%"
        autocmd BufReadPost *.odt,*.odp silent %!odt2txt "%"
        autocmd BufReadPost *.pdf silent %!pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78
        autocmd BufReadPost *.rtf silent %!unrtf --text "%"
    augroup end
endif

" =======================
" Filetype specific
" =======================
map <F3> :call Compile()<CR>

function! Compile()
    if &filetype == "c"
        call CompileC()
    elseif &filetype == "cpp"
        call CompileCpp()
    elseif &filetype == "java"
        call CompileJava()
    else
        echo "Compile function for '" . &filetype . "' not found"
    endif
endfunction

map <F4> :call RunFile()<CR>

function! RunFile()
    if &filetype == "c" || &filetype == "cpp"
        call RunExec()
    elseif &filetype == "java"
        call RunClass()
    elseif &filetype == "python"
        call RunPython()
    else
        echo "Run function for '" . &filetype . "' not found"
    endif
endfunction

map <Leader><F4> :call ChangeRunSettings()<CR>

function! ChangeRunSettings()
    if &filetype == "java"
        " change class file
        if exists("b:class")
            echo "class = '" . b:class . "'"
        endif

        let b:class = input("class = ")
    else
        echo "RunSettings function for '" . &filetype . "' not found"
    endif
endfunction

" =======================
" C section
" =======================
function! CompileC()
    write

    if glob("Makefile") != ""
        make
    else
        execute '!' . g:CC . ' "%" -o "%:p:r"'
    endif
endfunction

" run system executable file - used for C and C++
function! RunExec()
    execute '!"%:p:r"'
endfunction

" =======================
" C++ section
" =======================
function! CompileCpp()
    write

    if glob("Makefile") != ""
        make
    else
        execute '!g++ "%" -o "%:p:r"'
    endif
endfunction

" =======================
" Java section
" =======================
function! CompileJava()
    write

    setlocal makeprg=javac\ -cp\ \"%:p:h\"\ %\ $*
    make
endfunction

function! RunClass()
    if !exists("b:class")
        let b:class = expand("%:t:r")
    endif

    execute '!java -cp "%:p:h" ' . b:class
endfunction

" =======================
" Python section
" =======================
function! RunPython()
    write

    setlocal makeprg=python\ %\ $*
    make
endfunction


" ================================================
" Configuration variables
" ================================================
let g:CC = "clang"

" vim: set ts=4 sw=4 sts=4 et :
