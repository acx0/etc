" Custom Rust settings

source ~/.vim/ftplugin/util.vim

nnoremap <buffer> <Leader><F3> :call CheckRust()<CR>
function! CheckRust()
    update
    call PrintSeparator()
    execute '!cargo check'
endfunction

nnoremap <buffer> <F3> :call CompileRust()<CR>
function! CompileRust()
    update
    call PrintSeparator()
    execute '!cargo build'
endfunction

nnoremap <buffer> <F4> :call RunExecutable()<CR>
function! RunExecutable()
    update
    call PrintSeparator()
    execute '!cargo run'
endfunction

nnoremap <buffer> <F5> :call RunTests()<CR>
function! RunTests()
    update
    call PrintSeparator()
    execute '!cargo test'
endfunction

nnoremap <buffer> <Leader>dg :YcmDiags<CR>
nnoremap <buffer> <Leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <buffer> <Leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <buffer> <Leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <buffer> <Leader>gt :YcmCompleter GetType<CR>
nnoremap <buffer> <Leader>fi :YcmCompleter FixIt<CR>
