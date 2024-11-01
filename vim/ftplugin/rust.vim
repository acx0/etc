" Custom Rust settings

source ~/.vim/ftplugin/util.vim
source ~/.vim/ftplugin/ycm-mappings.vim

" note: `inoremap` will immediately substitute lhs with rhs whereas `iabbrev` requires another char to be inputted
inoremap <buffer> OK Ok
inoremap <buffer> ;; ::
inoremap <buffer> sst String

setlocal colorcolumn=100

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

    if has("unix") && glob("[Mm]akefile") != "" && !empty(system("grep '^build-dbg:' [Mm]akefile"))
        execute '!make build-dbg'
    elseif has("unix") && glob("[Mm]akefile") != "" && !empty(system("grep '^build-win-dbg:' [Mm]akefile"))
        execute '!make build-win-dbg'
    else
        execute '!cargo build'
    endif
endfunction

nnoremap <buffer> <F4> :call RunExecutable()<CR>
function! RunExecutable()
    update
    call PrintSeparator()

    if has("unix") && glob("[Mm]akefile") != "" && !empty(system("grep '^test:' [Mm]akefile"))
        execute '!make test'
    elseif has("unix") && glob("[Mm]akefile") != "" && !empty(system("grep '^run:' [Mm]akefile"))
        execute '!make run'
    else
        execute '!cargo run'
    endif
endfunction

nnoremap <buffer> <F5> :call RunTests()<CR>
function! RunTests()
    update
    call PrintSeparator()
    execute '!cargo test'
endfunction
