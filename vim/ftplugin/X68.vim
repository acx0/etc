" Custom 68000 Assembly (X68) settings

setlocal filetype=asm

" use hard tabs
setlocal tabstop=8
setlocal softtabstop=0
setlocal shiftwidth=8
setlocal noexpandtab

" open in easy68k to compile/run
nnoremap <buffer> <F3> :call OpenEasy68k()<CR>

function! OpenEasy68k()
    update
    !easy68k "%"
endfunction
