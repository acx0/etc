" Custom Python settings
" Notes:
"   - 'omnifunc' automatically set when 'filetype plugin on' is set

source ~/.vim/ftplugin/util.vim

" quick run function
nnoremap <buffer> <F4> :call RunPython()<CR>

function! RunPython()
    update
    call PrintSeparator()
    !python3 "%"
endfunction

nnoremap <buffer> <Leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <buffer> <Leader>gt :YcmCompleter GetType<CR>
