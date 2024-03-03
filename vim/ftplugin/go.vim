" Custom Go settings

setlocal tabstop=4

" note: source this before overriding keybinds with vim-go mappings
source ~/.vim/ftplugin/ycm-mappings.vim

" note: vim-go remaps <C-]> to :GoDef
nnoremap <buffer> <Leader>re :GoReferrers<CR>
nnoremap <buffer> <Leader>gc :GoCallers<CR>
nnoremap <buffer> <Leader>gi :GoImplements<CR>
nnoremap <buffer> <Leader>im :GoImports<CR>
nnoremap <buffer> <Leader>gl :GoLint!<CR>
nnoremap <buffer> <Leader>gml :GoMetaLinter!<CR>

nnoremap <buffer> <F4> :call RunMain()<CR>
function! RunMain()
    update
    call PrintSeparator()
    execute '!go run .'
endfunction
