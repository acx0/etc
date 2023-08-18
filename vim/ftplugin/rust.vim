" Custom Rust settings

source ~/.vim/ftplugin/util.vim
source ~/.vim/ftplugin/ycm-mappings.vim

" note: `inoremap` will immediately substitute lhs with rhs whereas `iabbrev` requires another char to be inputted
inoremap <buffer> OK Ok
inoremap <buffer> ;; ::
inoremap <buffer> sst String

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
