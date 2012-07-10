" Custom Java settings

source ~/.vim/ftplugin/util.vim

" ':make' support
setlocal makeprg=javac\ -cp\ \"%:p:h\"\ %\ $*

" java-related plugin settings
" support for java omnicomplete using javacomplete plugin
setlocal omnifunc=javacomplete#Complete

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
