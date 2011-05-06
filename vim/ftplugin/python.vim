" Custom Python settings

" quick run function
nmap <buffer> <F4> :call RunPython()<CR>

function! RunPython()
    write

    setlocal makeprg=python\ %\ $*
    make!
endfunction
