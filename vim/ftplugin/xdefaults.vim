" Custom Xresources settings

source ~/.vim/ftplugin/util.vim

nnoremap <buffer> <Leader>re :call ReloadXresources()<CR>
function! ReloadXresources()
    update
    call PrintSeparator()

    execute '!xrdb -load ~/.Xresources'
endfunction
