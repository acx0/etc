" Custom Java settings

source ~/.vim/ftplugin/util.vim

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

nnoremap <buffer> <Leader>dg :YcmDiags<CR>
nnoremap <buffer> <Leader>fi :YcmCompleter FixIt<CR>
nnoremap <buffer> <Leader>gd :YcmCompleter GoTo<CR>
nnoremap <buffer> <Leader>gt :YcmCompleter GetType<CR>
nnoremap <buffer> <Leader>gi :YcmCompleter GoToImplementation<CR>
nnoremap <buffer> <Leader>re :YcmCompleter GoToReferences<CR>
" note: leave trailing space below
nnoremap <buffer> <Leader>rf :YcmCompleter RefactorRename 
" note: if typing out importable type, explicitly invoking and accepting
" completion (C-space, C-y) will add missing import
nnoremap <buffer> <Leader>im :YcmCompleter OrganizeImports<CR>
