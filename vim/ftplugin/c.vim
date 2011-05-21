" Custom C(++) settings

" quick compile/run functions
nmap <buffer> <F3> :call CompileC()<CR>

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

nmap <buffer> <F4> :call RunExec()<CR>

function! RunExec()
    execute '!"%:p:r"'
endfunction
