" Custom C(++) settings
" Notes:
"   - 'omnifunc' automatically set when 'filetype plugin on' is set

source ~/.vim/ftplugin/util.vim

" put scope declarations (public, private, protected) 0 characters away from indent of surrounding block
set cinoptions+=g0

" set default compiler
if !exists("g:CC")
    if has("unix") && filereadable("/usr/bin/clang")
        let g:CC = "clang -std=gnu89"
        let g:CPP = "clang++"
    else
        let g:CC = "gcc"
        let g:CPP = "g++"
    endif
endif

if !exists("b:cflags")
    let b:cflags = ""
endif

" colour output lost when output of ':make' piped through tee, see ':h shellpipe'
if !exists("b:enable_colour_output")
    let b:enable_colour_output = 1
endif

" settings for vim-fswitch plugin
if exists(":FSHere")
    nnoremap <buffer> <Leader>fs :FSHere<CR>

    augroup fswitch_custom
        autocmd!
        autocmd BufEnter *.h let b:fswitchdst = 'cc,cpp,c'
        autocmd BufEnter *.cc,*.cpp let b:fswitchdst = 'h'
    augroup end
endif

" add custom tags for C++
if &filetype == "cpp"
    setlocal tags+=~/.tags/cpp
endif

" generate ctags for directory of active buffer
nnoremap <buffer> <F11> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q "%:p:h"<CR>

" quick compile/run functions
nnoremap <buffer> <F3> :call CompileC()<CR>

function! CompileC()
    update
    call PrintSeparator()

    if glob("Makefile") != ""
        execute b:enable_colour_output == 1 ? '!make' : 'make!'
    else
        execute '!' . (&filetype == "c" ? g:CC : g:CPP) . ' "%" -o "%:p:r" ' . b:cflags
    endif
endfunction

nnoremap <buffer> <Leader><F3> :call GetCFlags()<CR>

function! GetCFlags()
    echo 'b:cflags = "' . b:cflags . '"'
    let b:cflags = input("let b:cflags = ", b:cflags)
endfunction

nnoremap <buffer> <F4> :call RunExecutable()<CR>

function! RunExecutable()
    call PrintSeparator()

    if has("unix") && glob("[Mm]akefile") != "" && !empty(system("grep '^run:' [Mm]akefile"))
        make! run
    else
        execute '!"%:p:r"'
    endif
endfunction
