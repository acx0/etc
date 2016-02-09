" ~/.vimrc

" Notes:
"   - filetype specific functions and settings are placed in ~/.vim/ftplugin/<ft>.vim

" ---> Startup {{{
" prevent vim from emulating vi
set nocompatible    " set explicitly since not set when vimrc sourced with '-u' flag

" setup vundle to manage all other plugins
filetype off    " temporarily disabled (required); enabled below

" use '.vim' directory instead of 'vimfiles' under windows
if has("win32")
    set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after
endif

set runtimepath+=~/.vim/vundle  " add vundle to runtimepath
call vundle#begin()

" --managed / active plugins
if exists(":Plugin")
    Plugin 'acx0/Conque-Shell'
    Plugin 'acx0/Vim-JDE'
    "Plugin 'altercation/vim-colors-solarized'
    "Plugin 'Arduino-syntax-file'
    Plugin 'bufkill.vim'
    "Plugin 'ciaranm/inkpot'
    Plugin 'cool.vim'
    Plugin 'derekwyatt/vim-fswitch'
    Plugin 'derekwyatt/vim-protodef'
    Plugin 'DrawIt'
    "Plugin 'github-theme'
    "Plugin 'godlygeek/csapprox'
    Plugin 'godlygeek/tabular'
    Plugin 'IndentConsistencyCop'
    Plugin 'indenthaskell.vim'
    Plugin 'indentpython.vim'
    Plugin 'javacomplete'
    Plugin 'junegunn/seoul256.vim'
    "Plugin 'kana/vim-submode'
    "Plugin 'kien/ctrlp.vim'
    "Plugin 'LaTeX-Suite-aka-Vim-LaTeX'
    "Plugin 'Lokaltog/vim-easymotion'
    Plugin 'majutsushi/tagbar'
    Plugin 'mbbill/undotree'
    Plugin 'mileszs/ack.vim'
    Plugin 'msanders/snipmate.vim'
    Plugin 'nathanaelkane/vim-indent-guides'
    "Plugin 'scrooloose/nerdtree'
    "Plugin 'sjl/gundo.vim'
    "Plugin 'Sorcerer'
    Plugin 'SyntaxAttr.vim'
    "Plugin 'tomasr/molokai'
    Plugin 'tomtom/tcomment_vim'
    Plugin 'tpope/vim-surround'
    Plugin 'trapd00r/neverland-vim-theme'
    Plugin 'VimCoder.jar'
    "Plugin 'Wombat'
    Plugin 'wombat256.vim'
    "Plugin 'xoria256.vim'
    "Plugin 'Zenburn'
    "Plugin 'zenesque.vim'

    if filereadable("/usr/bin/clang")
        Plugin 'Rip-Rip/clang_complete'
    else
        Plugin 'OmniCppComplete'
    endif
endif

call vundle#end()
" }}}

" ---> User interface {{{
" use <Space> as mapleader, easier to reach than \
let mapleader = " "
" easier to reach than Esc or Ctrl-[
inoremap jk <Esc>

set backspace=indent,eol,start  " make backspace work like 'normal' text editors

" --history
set history=500    " history of commands and searches
set undolevels=500 " changes to be remembered

" --interface appearance
syntax enable    " enable syntax highlighting and allow custom highlighting
set title        " set title to filename and modification status
set number       " show line numbers
"set ruler        " always show current position
set showcmd      " show the command being typed
set showmode     " show current mode (insert, visual, etc.)
set laststatus=2 " always show status line

" useful, but can be slow at times
"set cursorline   " highlight current line
"set cursorcolumn " highlight current column

nnoremap <Leader>cl :setlocal cursorline! cursorline?<CR>

nnoremap <Leader>rn :set relativenumber! relativenumber?<CR>

" --searching
set ignorecase " ignore case when searching
set smartcase  " case sensitive only when capital letter in expression
set hlsearch   " highlight search terms
set incsearch  " show matches as they are found

" toggle hlsearch and show current value
nnoremap <Leader>h :set hlsearch! hlsearch?<CR>

" --feedback
set showmatch    " show matching braces when typed or under cursor
set matchtime=1  " length of time for 'showmatch'
set cpoptions+=$ " put '$' at end of changed text instead of removing it

" --redrawing / warnings
set lazyredraw   " don't redraw screen when executing macros
set noerrorbells " no bell for error messages
set visualbell   " use whatever 't_vb' is set to as a bell
set t_vb=        " set to nothing (disable)

" restore 't_vb' since it is reset after the GUI starts
if has("gui_running")
    augroup disable_gui_visualbell
        autocmd!
        autocmd GUIEnter * set t_vb=
    augroup end
endif

" --insert completion
set completeopt-=preview    " disable 'preview' for insert mode completion

" --command-line completion
set wildmenu                                 " enhanced command-line completion
"set wildmode=list:longest,full               " list matches and complete till longest common string, then cycle through them
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o " filetypes to ignore in file related operations

" ignore case when completing filenames and directories when supported
if v:version > 703 || (v:version == 703 && has("patch72"))
    set wildignorecase
endif

" --spell checking
set spelllang=en_ca " set region to Canadian English

" toggle spell checking and show current value
" z= on highlighted word gives correction suggestions
nnoremap <Leader>ss :setlocal spell! spell?<CR>

" --visual theme and appearance
set background=dark

" colorscheme modification
let g:neverland_bold = 0         " disable bold
let g:molokai_original = 1       " lighter background in gVim
let g:solarized_termcolors = 256 " use degraded colors in terminal vim
let g:zenburn_high_Contrast = 1  " darker colors

if has("gui_running")
    " gVim specific

    " font setup
    if has("unix")
        set guifont=Terminus\ 9
        "set guifont=Monospace\ 9
    elseif has("win32")
        set guifont=ter-112n:h9
        "set guifont=Lucida_Console:h9:cANSI
    endif

    colorscheme neverland-mod

    set guicursor+=a:blinkon0   " disable blinking cursor for gVim

    " gVim interface modification
    set guioptions-=m " remove menu bar
    set guioptions-=T " remove toolbar
    set guioptions-=r " remove right scrollbar
    set guioptions-=R " remove right vertical split scrollbar
    set guioptions-=l " remove left scrollbar
    set guioptions-=L " remove left vertical split scrollbar
    set guioptions-=b " remove bottom scrollbar

    " toggle menu bar and toolbar, respectively
    nnoremap <C-F1> :call ToggleMenuBar()<CR>
    nnoremap <C-F2> :call ToggleToolbar()<CR>

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
else
    " terminal vim specific

    if &t_Co == 256
        colorscheme neverland-mod
    else
        colorscheme desert
    endif
endif

" --statusline
" default statusline (with 'set ruler'): '%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P'
let s:common_status = "\ [%{strlen(&fileencoding)?&fileencoding:&encoding}:%{&fileformat}]\ %y\ %w%=%-14.(%l,%c%V%)\ %P\ [%L]"

" use smart statusline if 256 colours are available or if gVim is running
if &t_Co == 256 || has("gui_running")
    set statusline=%!MyStatusLine('Enter')

    " colours
    " 113 / #87d75f : light-green
    " 203 / #ff5f5f : red
    " 208 / #ff8700 : orange
    " 212 / #ff87d7 : pink
    highlight StatColor guibg=#87d75f guifg=Black ctermbg=113 ctermfg=Black
    highlight Modified guibg=#ff8700 guifg=Black ctermbg=208 ctermfg=Black

    augroup smart_statusline
        autocmd!
        autocmd WinEnter * setlocal statusline=%!MyStatusLine('Enter')
        autocmd WinLeave * setlocal statusline=%!MyStatusLine('Leave')

        autocmd InsertEnter * call InsertStatuslineColor(v:insertmode)
        autocmd InsertLeave * highlight StatColor guibg=#87d75f guifg=Black ctermbg=113 ctermfg=Black
        autocmd InsertLeave * highlight Modified guibg=#ff8700 guifg=Black ctermbg=208 ctermfg=Black
    augroup end

    function! MyStatusLine(mode)
        let l:statusline = ""
        if a:mode == "Enter"
            let l:statusline .= "%#StatColor#"
        endif

        let l:statusline .= "\(%n\)\ %t\ "
        if a:mode == "Enter"
            let l:statusline .= "%*"
        endif

        let l:statusline .= "%#Modified#%m"
        if a:mode == "Leave"
            let l:statusline .= "%*%r"
        elseif a:mode == "Enter"
            let l:statusline .= "%r%*"
        endif

        let l:statusline .= s:common_status
        return l:statusline
    endfunction

    function! InsertStatuslineColor(mode)
        if a:mode == "i"
            highlight StatColor guibg=#ff5f5f ctermbg=203
        elseif a:mode == "r"
            highlight StatColor guibg=#ff87d7 ctermbg=212
        elseif a:mode == "v"
            highlight StatColor guibg=#ff87d7 ctermbg=212
        else
            highlight StatColor guibg=#ff5f5f ctermbg=203
        endif
    endfunction
else
    let &statusline = "\(%n\)\ %t\ %m%r" . s:common_status
endif

" show full path of file in buffer
nnoremap <Leader>fp :echo expand("%:p")<CR>

" --movement / navigation
set scrolloff=5       " scrolling starts 5 lines before window border
set virtualedit=block " allow cursor to move past last character on line in visual block mode

" redraw window so search terms are centered
nnoremap n nzz
nnoremap N Nzz

" easier window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" --screen management
" window split shortcuts
nnoremap <Leader>swh :topleft vnew<CR>
nnoremap <Leader>swl :botright vnew<CR>
nnoremap <Leader>swk :topleft new<CR>
nnoremap <Leader>swj :botright new<CR>

nnoremap <Leader>sh :leftabove vnew<CR>
nnoremap <Leader>sl :rightbelow vnew<CR>
nnoremap <Leader>sk :leftabove new<CR>
nnoremap <Leader>sj :rightbelow new<CR>

" window management shortcuts
nnoremap <Leader>H <C-w>H
nnoremap <Leader>J <C-w>J
nnoremap <Leader>K <C-w>K
nnoremap <Leader>L <C-w>L

" tab creation shortcuts
"nnoremap <Leader>tt :tabs<CR>
nnoremap <Leader>tn :tabnew<CR>
nnoremap <Leader>te :tabedit
nnoremap <Leader>tc :tabclose<CR>
nnoremap <Leader>tm :tabmove

" auto-expand path to parent of current file; for windows, (v)splits, and tabs
nnoremap <Leader>ew :edit <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <Leader>es :split <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <Leader>ev :vsplit <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <Leader>et :tabedit <C-R>=expand("%:p:h") . "/" <CR>

" --mouse input
" toggle mouse support; when enabled, mouse selection goes into visual mode
nnoremap <F12> :call ToggleMouse()<CR>

function! ToggleMouse()
    if !exists("s:old_mouse")
        let s:old_mouse = "a"
    endif

    if &mouse == ""
        let &mouse = s:old_mouse
    else
        let s:old_mouse = &mouse
        let &mouse = ""
    endif

    echo "  mouse=" . &mouse
endfunction
" }}}

" ---> File settings {{{
" --filetype detection
filetype plugin indent on   " let vim detect filetype and load appropriate scripts

" --character encoding
set encoding=utf-8                             " encoding used within vim
set fileencodings=ucs-bom,utf-8,default,latin1 " encodings to try when editing a file

" --code folding
set foldmethod=marker

" --line wrapping
nnoremap <Leader>tw :setlocal wrap! wrap?<CR>

" --backup / swap
" multiple combinations for backups, see ':h backup-table'
"set nobackup      " won't leave additional files after vim is closed
"set nowritebackup " keeps backup file while editing, deleted after
"set noswapfile    " keeps everything in memory

" --session restore
" jump to last position when reopening a file
augroup restore_position
    autocmd!
    autocmd BufReadPost * call RestorePosition()
augroup end

function! RestorePosition()
    if line("'\"") > 1 && line("'\"") <= line("$")
        normal! g`"
    endif
endfunction

" --buffer management
set hidden    " allow buffer to be changed without writing to disk
set autoread  " update file when externally modified
"set autochdir " change to directory of active buffer

" cd into directory of active buffer and display it
nnoremap <Leader>cd :lcd %:p:h<CR> :pwd<CR>

" clean up buffer list by wiping out unmodified, hidden, no name buffers
nnoremap <Leader>de :call RemoveEmptyBuffers()<CR>

function! RemoveEmptyBuffers()
    let s:empty_buffers = filter(range(1, bufnr("$")),
                \ "buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val) < 0 && !getbufvar(v:val, '&mod')")

    if !empty(s:empty_buffers)
        execute "bwipeout " . join(s:empty_buffers, " ")
    endif
endfunction

" --indenting
set fileformats=unix,dos,mac " try recognizing line endings in this order
set tabstop=8                " width of a tab character in spaces
set softtabstop=4            " defines number of spaces <Tab>/<BS> will insert/remove
set shiftwidth=4             " number of spaces to use for automatic indentation
set expandtab                " use spaces instead of tab characters; to insert real tab, use <C-v><Tab>
set autoindent               " fallback indenting, doesn't interfere with 'filetype indent'; see ':h C-indenting' for comparison
set shiftround               " round indent to multiple of shiftwidth

" quickly switch between different indentation styles
command! -nargs=* SetTab call SetTab(<f-args>, 1)
function! SetTab(size, type, print)
    if a:type == "soft"
        let &l:tabstop = 8
        let &l:softtabstop = a:size
        let &l:shiftwidth = a:size
        setlocal expandtab
    elseif a:type == "hard"
        let &l:tabstop = a:size
        let &l:softtabstop = 0
        let &l:shiftwidth = a:size
        setlocal noexpandtab
    else
        echoerr "E: Tab type '" . a:type . "' not defined"
        return -1
    endif

    if a:print == 1
        call SummarizeTabs()
    endif
endfunction

function! SummarizeTabs()
    echon "tabstop=" . &l:tabstop
    echon " softtabstop=" . &l:softtabstop
    echon " shiftwidth=" . &l:shiftwidth
    echon &l:expandtab == 1 ? " expandtab" : " noexpandtab"
endfunction

"call SetTab(4, "soft", 0)

" --copying / pasting
" allow vim commands to copy to system clipboard (*)
" for X11:
"   + is the clipboard register (Ctrl-{c,v})
"   * is the selection register (middle click, Shift-Insert)
set clipboard=unnamed

" use clipboard register when supported (X11 only)
if has("unnamedplus")
    set clipboard+=unnamedplus
endif

" set paste to prevent unexpected code formatting when pasting text
" toggle paste and show current value ('pastetoggle' doesn't)
nnoremap <Leader>p :set paste! paste?<CR>
"set pastetoggle=<Leader>p

" --prose writing
" modes:
"   notes - hard wrap at 78 characters, don't reformat text after changes
"   email - hard wrap at 78 characters, reformat text after changes
"   essay - soft wrap at end of line (for copying to other word processors)
let g:default_prose_mode = "notes"

nnoremap <Leader>tp :call ToggleProse()<CR>

function! ToggleProse()
    if exists("b:prose_mode") && b:prose_mode != "off"
        call SetProse("off")
    else
        call SetProse(g:default_prose_mode)
    endif
endfunction

command! -nargs=1 SetProse call SetProse(<f-args>)
function! SetProse(mode)
    if !exists("b:prose_mode")
        let b:prose_mode = a:mode
        let b:old_formatoptions = &formatoptions
        let b:old_textwidth = &textwidth
    endif

    setlocal nonumber
    setlocal wrap
    setlocal spell

    if a:mode == "notes"
        setlocal textwidth=78
        setlocal formatoptions=tcq
    elseif a:mode == "email"
        setlocal textwidth=72
        setlocal formatoptions=tcqa
    elseif a:mode == "essay"
        setlocal linebreak
        setlocal formatoptions=q
    else
        setlocal number
        setlocal nospell
        setlocal nolinebreak

        let &l:textwidth = b:old_textwidth
        let &l:formatoptions = b:old_formatoptions

        if a:mode != "off"
            echoerr "E: Prose mode '" . a:mode . "' not defined"
            return -1
        endif
    endif

    let b:prose_mode = a:mode
    echo a:mode == "off" ? "noprose" : "  prose (" . a:mode . ")"
endfunction

" --file / text manipulation functions
" quickly edit/source vimrc
nnoremap <Leader>er :edit $MYVIMRC<CR>
nnoremap <Leader>sr :source $MYVIMRC<CR>

" create parent directories for non-existing path
nnoremap <Leader>md :call MkdirTree()<CR>

function! MkdirTree()
    " windows mkdir behaves like 'mkdir -p' if command extensions are enabled
    execute 'silent !mkdir ' . (has("win32") ? "" : "-p ") . expand("%:p:h")
    redraw!
    echo "mkdir " . (has("win32") ? "" : "-p ") . expand("%:p:h")
endfunction

" view diff between current buffer and original file it was loaded from
nnoremap <Leader>df :call DiffOrig()<CR>

function! DiffOrig()
    if !exists("b:diff_active") && &buftype == "nofile"
        echoerr "E: Cannot diff a scratch buffer"
        return -1
    elseif expand("%") == "" || !filereadable(expand("%"))
        echoerr "E: Buffer doesn't exist on disk"
        return -1
    endif

    if !exists("b:diff_active") || b:diff_active == 0
        let b:diff_active = 1
        let l:orig_filetype = &l:filetype

        leftabove vnew
        let t:diff_buffer = bufnr("%")
        set buftype=nofile

        read #
        0delete_
        let &l:filetype = l:orig_filetype

        diffthis
        wincmd p
        diffthis
    else
        diffoff
        execute "bdelete " . t:diff_buffer
        let b:diff_active = 0
    endif
endfunction

" toggle diff option for window
nnoremap <Leader>td :call ToggleDiff()<CR>

function! ToggleDiff()
    if &l:diff == 0
        diffthis
    else
        diffoff
    endif
    set diff?
endfunction

" remove trailing whitespace
nnoremap _$ :call PreservePosition("%s/\\s\\+$//e")<CR>

" auto-indent entire file
nnoremap _= :call PreservePosition("normal! gg=G")<CR>

function! PreservePosition(command)
    " save last search, and cursor position
    let l:search = @/
    let l:line = line(".")
    let l:column = col(".")

    execute a:command
    " restore previous search history, and cursor position
    let @/ = l:search
    call cursor(l:line, l:column)
endfunction

" write to root-owned file when running as non-root
command! W write !sudo tee % > /dev/null

" append modeline after last line in buffer
" use substitute() instead of printf() to handle "%%s" modeline in LaTeX files
nnoremap <Leader>ml :call AppendModeline()<CR>

function! AppendModeline()
    let l:modeline = printf(" vim: set ts=%d sts=%d sw=%d %s :",
                \ &l:tabstop, &l:softtabstop, &l:shiftwidth, &l:expandtab ? "et" : "noet")
    let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
    call append(line("$"), "")
    call append(line("$"), l:modeline)
endfunction

if has("unix")
    " select and open file using ranger file manager
    nnoremap <Leader>fm :call RangerSelectFile()<CR>

    let s:selected_file = $HOME . "/.config/ranger/vim_edit"

    function! RangerSelectFile()
        if !executable("ranger")
            return
        endif

        execute 'silent !ranger --choosefile ' . s:selected_file . ' "%:p:h"'
        if filereadable(s:selected_file)
            execute 'edit ' . substitute(system('cat ' . s:selected_file), ' ', '\\ ', 'g')
            execute 'silent !rm -f -- ' . s:selected_file
        endif
        redraw!
    endfun

    " open terminal in CWD
    command! Terminal silent !term

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
" --vundle
let g:vundle_default_git_proto = "git"

" --snipmate.vim
" use custom snippets
let g:snippets_dir = "~/.vim/snippets/"

" --tagbar
nnoremap <F2> :TagbarToggle<CR>

" --vim-indent-guides
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

" --gundo.vim
"nnoremap <F5> :GundoToggle<CR>
"let g:gundo_width = 33
"let g:gundo_preview_bottom = 1

" --undotree
nnoremap <F5> :UndotreeToggle<CR>

" --clang_complete
"let g:clang_debug = 1
let g:clang_complete_auto = 0
let g:clang_use_library = 1
let g:clang_library_path = "/usr/lib/llvm-3.6/lib"

" --OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 0      " autocomplete after .
let OmniCpp_MayCompleteArrow = 0    " autocomplete after ->
let OmniCpp_MayCompleteScope = 0    " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

" --Conque-Shell
let g:ConqueTerm_Color = 1  " only enable colours for the most recent 200 lines

" --ack.vim
let g:ackprg = "ack-grep -H --nocolor --nogroup --column"

" --SyntaxAttr.vim
nnoremap <Leader>st :call SyntaxAttr()<CR>

" --LaTeX-Suite-aka-Vim-LaTeX
let g:tex_flavor = "latex"
"let g:Tex_DefaultTargetFormat = "pdf"
"let g:Tex_ViewRule_dvi = "evince"
"let g:Tex_ViewRule_pdf = "evince"

" --vim-protodef
let g:disable_protodef_sorting = 1

" --tcomment_vim
let g:tcommentBlankLines = 0
" }}}

" vim: set ts=8 sts=4 sw=4 et :
