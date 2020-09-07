" Custom Go settings

setlocal tabstop=4

nnoremap <buffer> <Leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <buffer> <Leader>gt :YcmCompleter GetType<CR>
nnoremap <buffer> <Leader>fi :YcmCompleter FixIt<CR>

" note: vim-go remaps <C-]> to :GoDef
nnoremap <buffer> <Leader>re :GoReferrers<CR>
nnoremap <buffer> <Leader>gc :GoCallers<CR>
nnoremap <buffer> <Leader>gi :GoImplements<CR>
nnoremap <buffer> <Leader>im :GoImports<CR>
nnoremap <buffer> <Leader>gl :GoLint!<CR>
nnoremap <buffer> <Leader>gml :GoMetaLinter!<CR>
