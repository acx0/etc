" Custom JavaScript settings

source ~/.vim/ftplugin/util.vim
source ~/.vim/ftplugin/ycm-mappings.vim

setlocal tabstop=8
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal expandtab

nnoremap <buffer> <F4> :call NpmStart()<CR>
function! NpmStart()
    update
    call PrintSeparator()
    execute '!npm start'
endfunction

nnoremap <buffer> <F5> :call NpmTest()<CR>
function! NpmTest()
    update
    call PrintSeparator()
    execute '!npm test'
endfunction
