" Custom Python settings
" Notes:
"   - 'omnifunc' automatically set when 'filetype plugin on' is set

" quick run function
nnoremap <buffer> <F4> :call RunPython()<CR>

function! RunPython()
    update
    !python "%"
endfunction
