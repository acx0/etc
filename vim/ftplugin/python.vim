" Custom Python settings
" Notes:
"   - 'omnifunc' automatically set when 'filetype plugin on' is set

source ~/.vim/ftplugin/util.vim

" quick run function
nnoremap <buffer> <F4> :call RunPython()<CR>

function! RunPython()
    update
    call PrintSeparator()
    !python "%"
endfunction
