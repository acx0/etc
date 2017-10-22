" Custom C(++) settings
" Notes:
"   - 'omnifunc' automatically set when 'filetype plugin on' is set

source ~/.vim/ftplugin/util.vim

" put scope declarations (public, private, protected) 0 characters away from indent of surrounding block
set cinoptions+=g0

set matchpairs+=<:>

" set default compiler
if !exists("g:CC")
    if has("unix") && executable("clang")
        let g:CC = "clang"
        let g:CXX = "clang++"
    else
        let g:CC = "gcc"
        let g:CXX = "g++"
    endif
endif

" flags are local to buffer
if !exists("b:CFLAGS")
    let b:CFLAGS = "-std=gnu89"
    let b:CXXFLAGS = "-std=c++11"
endif

" colour output lost when output of ':make' piped through tee, see ':h shellpipe'
if !exists("b:enable_colour_output")
    let b:enable_colour_output = 1
endif

" settings for vim-fswitch plugin
if exists(":FSHere")
    nnoremap <buffer> <Leader>fs :FSHere<CR>

    augroup fswitch_custom
        autocmd!
        autocmd BufEnter *.h let b:fswitchdst = 'cc,cpp,tcc,c'
        autocmd BufEnter *.cc,*.cpp,*.tcc let b:fswitchdst = 'h'

        " give preference to headers in current dir
        autocmd BufEnter *.h let b:fswitchlocs = './,reg:/include/src/,reg:/include.*/src/,ifrel:|/include/|../src|'
        autocmd BufEnter *.c let b:fswitchlocs = './,reg:/src/include/,reg:|src|include/**|,ifrel:|/src/|../include|'
        autocmd BufEnter *.cc,*.cpp,*.tcc let b:fswitchlocs = './,reg:/src/include/,reg:|src|include/**|,ifrel:|/src/|../include|'
    augroup end
endif

if &filetype == "cpp"
    inoremap std std::
endif

" generate ctags for directory of active buffer
nnoremap <buffer> <F11> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q "%:p:h"<CR>

" quick compile/run functions
nnoremap <buffer> <F3> :call CompileC()<CR>

function! CompileC()
    update
    call PrintSeparator()

    if glob("[Mm]akefile") != ""
        execute b:enable_colour_output == 1 ? '!make' : 'make!'
    else
        if &filetype == "cpp"
            execute '!' . g:CXX . ' ' . b:CXXFLAGS . ' -o "%:p:r" "%"'
        else
            execute '!' . g:CC . ' ' . b:CFLAGS . ' -o "%:p:r" "%"'
        endif
    endif
endfunction

nnoremap <buffer> <Leader><F3> :call GetCFlags()<CR>

function! GetCFlags()
    if &filetype == "cpp"
        echo 'b:CXXFLAGS = "' . b:CXXFLAGS . '"'
        let b:CXXFLAGS = input("let b:CXXFLAGS = ", b:CXXFLAGS)
    else
        echo 'b:CFLAGS = "' . b:CFLAGS . '"'
        let b:CFLAGS = input("let b:CFLAGS = ", b:CFLAGS)
    endif
endfunction

nnoremap <buffer> <F4> :call RunExecutable()<CR>

function! RunExecutable()
    call PrintSeparator()
    update

    if has("unix") && glob("[Mm]akefile") != "" && !empty(system("grep '^test:' [Mm]akefile"))
        make! -j test
    elseif has("unix") && glob("[Mm]akefile") != "" && !empty(system("grep '^run:' [Mm]akefile"))
        make! -j run
    else
        execute '!"%:p:r"'
    endif
endfunction

nnoremap <Leader>re :%!clang-format<CR>
