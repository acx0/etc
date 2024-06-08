" ~/.vimrc

" Notes:
"   - filetype specific functions and settings are placed in ~/.vim/ftplugin/<ft>.vim

" ---> Startup {{{
" prevent vim from emulating vi
set nocompatible    " set explicitly since not set when vimrc sourced with '-u' flag

" use '.vim' directory instead of 'vimfiles' under windows
if has("win32")
    set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after
endif

" --managed / active plugins
runtime vim-plug/plug.vim
call plug#begin("~/.vim/plugged")

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'airblade/vim-gitgutter'
Plug 'cespare/vim-toml'
Plug 'derekwyatt/vim-fswitch'
Plug 'derekwyatt/vim-protodef'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'godlygeek/tabular'
Plug 'hashivim/vim-terraform'
Plug 'inkarkat/vim-IndentConsistencyCop'
Plug 'itspriddle/vim-shellcheck'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'LnL7/vim-nix'
Plug 'majutsushi/tagbar'
Plug 'mbbill/undotree'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'qpkorr/vim-bufkill'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
Plug 'rust-lang/rust.vim'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/DrawIt'
Plug 'vim-scripts/SyntaxAttr.vim'

Plug 'inkarkat/vim-ingo-library'
" requires: 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'

" note: ships with vim
packadd! matchit
" requires: matchit
Plug 'rhysd/conflict-marker.vim'

" requires: 'tpope/vim-fugitive'
Plug 'christoomey/vim-conflicted'

" note: ~/.vim/plugged/YouCompleteMe/third_party/ dir can grow over time with
" old archives/artifacts and completers, delete + reinstall plugin to clean
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py
            \ --clangd-completer
            \ --go-completer
            \ --rust-completer
            \ --java-completer
            \ --ts-completer
            \' }

" colourschemes
Plug 'gruvbox-community/gruvbox'
Plug 'sainnhe/sonokai'
Plug 'trapd00r/neverland-vim-theme'

call plug#end()
" }}}

" ---> User interface {{{
" use <Space> as mapleader, easier to reach than \
let mapleader = " "
" prevent <Space> from advancing cursor
nnoremap <Space> <Nop>
vnoremap <Space> <Nop>

" easier to reach than Esc or Ctrl-[
inoremap jk <Esc>

set backspace=indent,eol,start  " make backspace work like 'normal' text editors

" --interface appearance
syntax enable    " enable syntax highlighting and allow custom highlighting
set title        " set title to filename and modification status
set number       " show line numbers
"set ruler        " always show current position
set showcmd      " show the command being typed
set showmode     " show current mode (insert, visual, etc.)
set laststatus=2 " always show status line
set history=1000 " history of commands and searches

" useful, but can be slow at times
"set cursorline   " highlight current line
"set cursorcolumn " highlight current column
nnoremap <Leader>cl :setlocal cursorline! cursorline?<CR>

nnoremap <Leader>rn :set relativenumber! relativenumber?<CR>

" always render column to prevent shifting when vim-gitgutter/YCM have something to report
"   - `signcolumn=number` results in only one of vim-gitgutter/YCM column markers rendering
set signcolumn=yes

" --searching
set ignorecase " ignore case when searching
set smartcase  " case sensitive only when capital letter in expression
set hlsearch   " highlight search terms
set incsearch  " show matches as they are found

" toggle hlsearch and show current value
nnoremap <Leader>hl :set hlsearch! hlsearch?<CR>

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
let s:active_colourscheme = "gruvbox"
let g:neverland_bold = 0         " disable bold

" override function call highlight colour in vim-go/syntax/go.vim
" note: this autocmd needs to be defined before `colourscheme` is set
augroup vim_go_highlight_override
    autocmd!
    autocmd ColorScheme * highlight default link goFunctionCall Statement
augroup end

function! TrySetColourscheme(colourscheme)
    try
        execute 'colorscheme ' . a:colourscheme
    catch /E185/    " 'Cannot find color scheme' error code
        " fall back to vendored colourscheme if vim-plug hasn't been run yet
        colorscheme neverland-mod
    endtry
endfunction

if has("gui_running")
    " gVim specific

    " font setup
    if has("unix")
        set guifont=SF\ Mono\ Bold\ 12
        " set guifont=Terminus\ 8
        " set guifont=Monospace\ 9
    elseif has("win32")
        set guifont=ter-112n:h9
        "set guifont=Lucida_Console:h9:cANSI
    endif

    call TrySetColourscheme(s:active_colourscheme)

    set guicursor+=a:blinkon0   " disable blinking cursor for gVim

    " gVim interface modification
    set guioptions-=m " remove menu bar
    set guioptions-=T " remove toolbar
    set guioptions-=r " remove right scrollbar
    set guioptions-=R " remove right vertical split scrollbar
    set guioptions-=l " remove left scrollbar
    set guioptions-=L " remove left vertical split scrollbar
    set guioptions-=b " remove bottom scrollbar
else
    " terminal vim specific

    if &t_Co == 256
        call TrySetColourscheme(s:active_colourscheme)
    else
        colorscheme desert
    endif
endif

nnoremap <Leader>c1 :call SetAndPersistColour("neverland-mod")<CR>
nnoremap <Leader>c2 :call SetAndPersistColour("gruvbox")<CR>
function! SetAndPersistColour(colourscheme)
    execute 'colorscheme ' . a:colourscheme
    let s:find_line = "let s:active_colourscheme = "
    execute 'silent !sed --follow-symlinks -i "s/^\(' . s:find_line . '\).*/\1\"' . a:colourscheme . '\"/" ~/.vimrc'
endfunction

" --statusline
function! PluginAvailable(name)
    " use vim-plug's `g:plugs` to determine if plugin is enabled and cloned
    return has_key(g:plugs, a:name) && isdirectory(g:plugs[a:name].dir)
endfunction

function! GetHunkSummary()
    let s:summary = ""
    let [added,modified,removed] = GitGutterGetHunkSummary()
    if added > 0
        let s:summary .= "+" . added
    endif
    if modified > 0
        if !empty(s:summary)
            let s:summary .= " "
        endif
        let s:summary .= "~" . modified
    endif
    if removed > 0
        if !empty(s:summary)
            let s:summary .= " "
        endif
        let s:summary .= "-" . removed
    endif
    return empty(s:summary)
                \ ? s:summary
                \ : "(" . s:summary . ")"
endfunction

function! GitStatusLine()
    return "%{FugitiveStatusline()}%{GetHunkSummary()}\ %{ConflictedVersion()}"
endfunction

" default statusline (with 'set ruler'): '%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P'
let s:common_status = "[%{strlen(&fileencoding)?&fileencoding:&encoding}:%{&fileformat}]"
let s:common_status .= "%y"
if PluginAvailable("vim-fugitive") && PluginAvailable("vim-gitgutter") && PluginAvailable("vim-conflicted")
    let s:common_status .= GitStatusLine()
endif
let s:common_status .= "\ %w%=%-14.(%l,%c%V%)\ %P\ [%L]"

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

        autocmd InsertEnter,Colorscheme * call InsertStatuslineColor(v:insertmode)
        autocmd InsertLeave,Colorscheme * highlight StatColor guibg=#87d75f guifg=Black ctermbg=113 ctermfg=Black
        autocmd InsertLeave,Colorscheme * highlight Modified guibg=#ff8700 guifg=Black ctermbg=208 ctermfg=Black
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

" jump list viewing/management
nnoremap <Leader>ju :jumps<CR>
nnoremap <Leader>cj :clearjumps<CR>

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
nnoremap <Leader>wo <C-w>o

" close current window's location list
nnoremap <Leader>lcl :lclose<CR>
" close current window's preview window
nnoremap <Leader>pc :pclose<CR>

nnoremap <Leader>ls :ls<CR>
nnoremap <Leader>bd :bdelete<CR>
nnoremap <Leader>BD :bdelete!<CR>
nnoremap <Leader>bn :buffer<Space>

" tab creation shortcuts
nnoremap <Leader>tt :tabs<CR>
nnoremap <Leader>tn :tabnew<CR>
nnoremap <Leader>tc :tabclose<CR>
nnoremap <Leader>tm :tabmove
nnoremap <Leader>nt <C-w>T

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

" delete comment character when joining commented lines
if v:version > 703 || (v:version == 703 && has("patch541"))
    set formatoptions+=j
endif

" --backup / swap
" multiple combinations for backups, see ':h backup-table'
"set nobackup      " won't leave additional files after vim is closed
"set nowritebackup " keeps backup file while editing, deleted after
"set noswapfile    " keeps everything in memory
set directory^=~/.vim/swap// " '//' directs swap file name to reference complete file path

" --persistent undo
set undolevels=1000 " changes to be remembered
set undofile
set undodir=~/.vim/undo

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
nnoremap <Leader>CD :call ChangeDirResolveSymlinks()<CR>
function! ChangeDirResolveSymlinks()
    execute "lcd " . fnamemodify(resolve(expand("%:p")), ":h")
    pwd
endfunction

nnoremap <Leader>ww :w<CR>
nnoremap <Leader>wq :wq<CR>
nnoremap <Leader>qq :q<CR>
nnoremap <Leader>E! :e!<CR>
nnoremap <Leader>RE :call ReopenFileResolveSymlinks()<CR>
function! ReopenFileResolveSymlinks()
    let l:resolved_file = resolve(expand("%:p"))
    " note:
    " - `bdelete` isn't sufficient; won't clear enough buffer metadata and results in vim just
    "   reopening file via originally-accessed symlink even with resolved path supplied
    " - prefer vim-bufkill's `BW` command to `bwipeout` to preserve window/tab configuration
    if exists(":BW") == 2
        BW
    else
        bwipeout
    endif
    execute "edit " . l:resolved_file
endfunction

" write to root-owned file when running as non-root
command! W execute 'silent write !sudo tee % >/dev/null' | edit!

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
nnoremap <Leader>pp :set paste! paste?<CR>
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
nnoremap <Leader>erc :edit $MYVIMRC<CR>
nnoremap <Leader>src :source $MYVIMRC<CR>

" create parent directories for non-existing path
nnoremap <Leader>md :call MkdirTree()<CR>

function! MkdirTree()
    " windows mkdir behaves like 'mkdir -p' if command extensions are enabled
    execute 'silent !mkdir ' . (has("win32") ? "" : "-p ") . expand("%:p:h")
    redraw!
    echo "mkdir " . (has("win32") ? "" : "-p ") . expand("%:p:h")
endfunction

" requires compilation with `+diff`
if has("diffopt")
    set diffopt+=algorithm:histogram
endif

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
    nnoremap <Leader>te :Terminal<CR>
endif
" }}}

" ---> Plugin configuration {{{
" --tagbar
nnoremap <F2> :TagbarToggle<CR>

" --vim-indent-guides
" reminders:
"   <Leader>ig
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_enable_on_vim_startup = 1
" let g:indent_guides_auto_colors = 1

if !has("gui_running")
    let g:indent_guides_auto_colors = 0
    augroup indent_guides_custom
        autocmd!
        " custom colours for indent guide lines
        " note: `g:colors_name` set by vim
        if g:colors_name == "neverland-mod"
            autocmd VimEnter,Colorscheme * highlight IndentGuidesEven ctermbg=234
            autocmd VimEnter,Colorscheme * highlight IndentGuidesOdd ctermbg=235
        elseif g:colors_name == "gruvbox"
            " use one shade higher since background is 235
            autocmd VimEnter,Colorscheme * highlight IndentGuidesEven ctermbg=236
            autocmd VimEnter,Colorscheme * highlight IndentGuidesOdd ctermbg=237
        endif
    augroup end
endif

" --undotree
nnoremap <Leader>ut :UndotreeToggle<CR>

" --SyntaxAttr.vim
nnoremap <Leader>st :call SyntaxAttr()<CR>

" --vim-protodef
let g:disable_protodef_sorting = 1

" --tcomment_vim
" reminders:
"   normal:
"       gcc g<c g>c
"   visual:
"       gc g< g>
let g:tcommentBlankLines = 0
" prefer C-style multiline comment markers for `~/.Xresources`; `!` can lead to parsing issues...
let g:tcomment_types = {
            \   "xdefaults": "/* %s */",
            \ }

" --YouCompleteMe
let g:ycm_auto_trigger = 1
let g:ycm_key_invoke_completion = "<C-Space>"
let g:ycm_global_ycm_extra_conf = "~/.vim/ycm_extra_conf.py"
let g:ycm_extra_conf_vim_data = ["&filetype"]
let g:ycm_error_symbol = ' !'
let g:ycm_warning_symbol = ' *'
let g:ycm_confirm_extra_conf = 0
" let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 0
" disable identifier completion engine by setting threshold very high
let g:ycm_min_num_of_chars_for_completion = 99
" extra rules for triggering semantic completion
" note: dictionary values are added to default trigger set for each language;
" default triggers can't be removed
let g:ycm_semantic_triggers = {
            \   'c,cpp,go,java,rust,javascript': [ 're!\w{2}' ],
            \ }
" disable automatic docstring popup
let g:ycm_auto_hover = ""
nnoremap <Leader>D <Plug>(YCMHover)

" for debugging; see also: `:YcmDebugInfo` for active log filenames
" let g:ycm_keep_logfiles = 1
" let g:ycm_log_level = "debug"
nnoremap <Leader>ycr :YcmRestartServer<CR>

" for temporarily disabling error checking
" let g:ycm_show_diagnostics_ui = 0
" let g:ycm_enable_diagnostic_signs = 0
" let g:ycm_enable_diagnostic_highlighting = 0

" --vim-go
" let g:go_highlight_types = 1
" let g:go_highlight_fields = 1
" let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1

" --rust.vim
let g:rustfmt_autosave = 1

" --fzf.vim
nnoremap <Leader>rg :Rg<CR>
nnoremap <Leader>ff :Files<CR>

" --vim-gitgutter
" reminders:
"   [c ]c (overridden)
"
"   <Leader>hp
"   <Leader>hs
"   <Leader>hu
"       note:
"       - gitgutter allows staging via symlinks to files in git repos whereas vim-fugitive doesn't
"       - can't unstage a staged hunk whereas vim-fugitive can
let g:gitgutter_terminal_reports_focus = 0
set updatetime=200      " (milliseconds) controls how quickly gitgutter updates diff state
" force-update signs across all visible buffers
nnoremap <Leader>gg :GitGutterAll<CR>

" --vim-fugitive
" reminders:
"   :G
"       cc ca
"       <CR>
"       = < >
"       i [c ]c
"       ( )
"       I P
"       gO O
"       dv
"       s u - U X
"           note: can use visual mode to select subrange to stage/unstage
" note: use standard do/dp when staging hunks
nnoremap <Leader>ga :Gvdiffsplit<CR>
nnoremap <Leader>gs :Git<CR>
nnoremap <Leader>GS :tabnew <bar> :Git <bar> :only<CR>
nnoremap <Leader>gci :Git commit<CR>

" --conflict-marker.vim
" reminders:
"   % (extended if matchit enabled)
"   [x ]x
"   ct co cn cb cB
" include text after markers when highlighting
let g:conflict_marker_begin = "^<<<<<<< .*$"
let g:conflict_marker_end   = "^>>>>>>> .*$"
let g:conflict_marker_common_ancestors = "^||||||| .*$"

" disable default highlight group in favor of custom colours
let g:conflict_marker_highlight_group = ""
highlight ConflictMarkerBegin ctermbg=29 guibg=#00875f
highlight ConflictMarkerOurs ctermbg=23 guibg=#005f5f
highlight ConflictMarkerCommonAncestors ctermbg=74 guibg=#5fafd7
highlight ConflictMarkerCommonAncestorsHunk ctermbg=67 guibg=#5f87af
" highlight ConflictMarkerCommonAncestorsHunk ctermbg=68 guibg=#5f87d7
highlight ConflictMarkerSeparator ctermbg=74 guibg=#5fafd7
highlight ConflictMarkerTheirs ctermbg=31 guibg=#0087af
highlight ConflictMarkerEnd ctermbg=37 guibg=#00afaf

" --vim-conflicted
" reminders:
"   :Conflicted
"       see also: ~/.gitconfig: alias.conflicted
"       note:
"       - provides cleaner view compared to default `git mergetool` window splitting
"       - toggle `diff` in `working` buffer to see conflict-marker.vim highlighting
"   dgl dgu
"       note: conflict-marker.vim offers more granular mappings for resolution
nnoremap <Leader>nc :GitNextConflict<CR>

" --vim-mark
" reminders:
"   {N}MarkSet
let g:mwDefaultHighlightingPalette = "extended"

" disable following default mappings added by plugin
nmap <Plug>IgnoreMarkSet <Plug>MarkSet
xmap <Plug>IgnoreMarkSet <Plug>MarkSet
nmap <Plug>IgnoreMarkRegex <Plug>MarkRegex
xmap <Plug>IgnoreMarkRegex <Plug>MarkRegex

nmap <F8> <Plug>MarkSet
xmap <F8> <Plug>MarkSet
nmap <Leader>ms <Plug>MarkSet
xmap <Leader>ms <Plug>MarkSet
nmap <Leader>mre <Plug>MarkRegex
xmap <Leader>mre <Plug>MarkRegex
nmap <Leader>mt <Plug>MarkToggle
nmap <Leader>mc <Plug>MarkConfirmAllClear
nmap <Leader>mC <Plug>MarkAllClear

" --bufkill.vim
" reminders:
"   :BD
"   <Leader>bb
"   <Leader>bf
"   <Leader>ba
"       note: using custom <Leader>bd map

" --vim-eunuch
" reminders:
"   :Delete
"   :Move
"   :Rename
"   :Chmod

" --DrawIt
" reminders:
"   <Leader>di
"   <Leader>ds

" --goyo.vim
nnoremap <Leader>gy :Goyo<CR>

" --rainbow_parentheses.vim
nnoremap <Leader>rp :RainbowParentheses!!<CR>

" --vim-terraform
nnoremap <Leader>tf :TerraformFmt<CR>
" }}}

" vim: set ts=8 sts=4 sw=4 et :
