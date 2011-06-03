" Custom C(++) settings

" add custom tags for cpp
if &filetype == "cpp"
    setlocal tags+=~/.tags/cpp
endif

" generate ctags for directory of active buffer
nnoremap <F11> :!ctags -R --c++-kinds=+pl --fields=+iaS --extra=+q "%:p:h"<CR>

" quick compile/run functions
nnoremap <buffer> <F3> :call CompileC()<CR>

function! CompileC()
    write

    if glob("Makefile") != ""
        make
    else
        if &filetype == "c"
            execute '!' . g:CC . ' "%" -o "%:p:r"'
        elseif &filetype == "cpp"
            execute '!g++ "%" -o "%:p:r"'
        endif
    endif
endfunction

nnoremap <buffer> <F4> :call RunExec()<CR>

function! RunExec()
    execute '!"%:p:r"'
endfunction
