" Custom C(++) settings

" Notes:
"   ~ 'omnifunc' automatically set when 'filetype plugin on' is set

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

" add custom tags for cpp
if &filetype == "cpp"
    setlocal tags+=~/.tags/cpp
endif

" generate ctags for directory of active buffer
nnoremap <buffer> <F11> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q "%:p:h"<CR>

" quick compile/run functions
nnoremap <buffer> <F3> :call CompileC()<CR>

function! CompileC()
    update

    if glob("Makefile") != ""
        make!
    else
        if &filetype == "c"
            execute '!' . g:CC . ' "%" -o "%:p:r"'
        elseif &filetype == "cpp"
            execute '!' . g:CPP . ' "%" -o "%:p:r"'
        endif
    endif
endfunction

nnoremap <buffer> <F4> :call RunExecutable()<CR>

function! RunExecutable()
    execute '!"%:p:r"'
endfunction
