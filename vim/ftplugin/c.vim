" Custom C settings

" quick compile/run functions
nmap <buffer> <F3> :call CompileC()<CR>

function! CompileC()
    write

    if glob("Makefile") != ""
        make
    else
        execute '!' . g:CC . ' "%" -o "%:p:r"'
    endif
endfunction

nmap <buffer> <F4> :call RunExec()<CR>

function! RunExec()
    execute '!"%:p:r"'
endfunction
