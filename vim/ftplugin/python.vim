" Custom Python settings

" quick run function
nnoremap <buffer> <F4> :call RunPython()<CR>

function! RunPython()
    update
    !python "%"
endfunction
