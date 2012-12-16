" Custom Perl settings

source ~/.vim/ftplugin/util.vim

" quick run function
nnoremap <buffer> <F4> :call RunPerl()<CR>

function! RunPerl()
    update
    call PrintSeparator()
    !perl -w "%"
endfunction
