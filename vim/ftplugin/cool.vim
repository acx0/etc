" Custom COOL settings

source ~/.vim/ftplugin/util.vim

" quick compile/run functions
nnoremap <buffer> <F3> :call CompileCool()<CR>

function! CompileCool()
    update
    call PrintSeparator()
    !coolc "%"
endfunction

nnoremap <buffer> <F4> :call RunCool()<CR>

function! RunCool()
    call PrintSeparator()
    execute '!spim "%:p:r.s"'
endfunction
