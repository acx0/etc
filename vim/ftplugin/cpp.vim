" Custom C++ settings

" quick compile/run functions
nmap <buffer> <F3> :call CompileCpp()<CR>

function! CompileCpp()
    write

    if glob("Makefile") != ""
        make
    else
        execute '!g++ "%" -o "%:p:r"'
    endif
endfunction

nmap <buffer> <F4> :call RunExec()<CR>

function! RunExec()
    execute '!"%:p:r"'
endfunction
