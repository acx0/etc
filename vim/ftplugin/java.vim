" Custom Java settings

source ~/.vim/ftplugin/util.vim

" note: if typing out importable type, explicitly invoking and accepting
" completion (C-space, C-y) will add missing import
source ~/.vim/ftplugin/ycm-mappings.vim

" ':make' support
setlocal makeprg=javac\ -cp\ \"%:p:h\"\ %\ $*

" quick compile/run functions
nnoremap <buffer> <F3> :call CompileJava()<CR>
function! CompileJava()
    update
    call PrintSeparator()
    make!
endfunction

nnoremap <buffer> <F4> :call RunClass()<CR>
function! RunClass()
    if !exists("b:class")
        let b:class = expand("%:t:r")
    endif

    call PrintSeparator()
    execute '!java -cp "%:p:h" ' . b:class
endfunction
