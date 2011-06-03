" Custom Java settings

" ':make' support
setlocal makeprg=javac\ -cp\ \"%:p:h\"\ %\ $*

" java-related plugin settings
" support for java omnicomplete using javacomplete plugin
setlocal omnifunc=javacomplete#Complete

" quick compile/run functions
nnoremap <buffer> <F3> :call CompileJava()<CR>

function! CompileJava()
    write
    make
endfunction

nnoremap <buffer> <F4> :call RunClass()<CR>

function! RunClass()
    if !exists("b:class")
        let b:class = expand("%:t:r")
    endif

    execute '!java -cp "%:p:h" ' . b:class
endfunction
