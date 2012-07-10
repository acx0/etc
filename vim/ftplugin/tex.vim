" Custom LaTeX settings

source ~/.vim/ftplugin/util.vim

if !exists("g:pdf_viewer")
    if has("unix")
        if filereadable("/usr/bin/zathura")
            let g:pdf_viewer = "zathura"
        elseif filereadable("/usr/bin/apvlv")
            let g:pdf_viewer = "apvlv"
        elseif filereadable("/usr/bin/evince")
            let g:pdf_viewer = "evince"
        else
            let g:pdf_viewer = ""
        endif
    endif
endif

" quick compile/view functions
nnoremap <buffer> <F3> :call CompileLaTeX()<CR>

function! CompileLaTeX()
    update
    call PrintSeparator()
    !pdflatex "%"
endfunction

nnoremap <buffer> <F4> :call ViewPDF()<CR>

function! ViewPDF()
    if g:pdf_viewer != ""
        if has("unix")
            execute '!' . g:pdf_viewer . ' "%:p:r.pdf" > /dev/null 2>&1 &'
        endif
    endif
endfunction
