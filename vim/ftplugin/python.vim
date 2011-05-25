" Custom Python settings

" ':make' support
setlocal makeprg=python\ %\ $*

" quick run function
nmap <buffer> <F4> :call RunPython()<CR>

function! RunPython()
    write
    make!
endfunction
