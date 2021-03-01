" Custom C(++) settings
" Notes:
"   - 'omnifunc' automatically set when 'filetype plugin on' is set

source ~/.vim/ftplugin/util.vim
source ~/.vim/ftplugin/ycm-mappings.vim

" put scope declarations (public, private, protected) 0 characters away from indent of surrounding block
set cinoptions+=g0

set matchpairs+=<:>

" see `:h ft-c-syntax`
let c_comment_strings = 1

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

if !exists("g:max_parallel_make_jobs")
    if has("unix")
        let g:max_parallel_make_jobs = str2nr(system("nproc"))
    elseif !empty($NUMBER_OF_PROCESSORS)
        " for windows
        let g:max_parallel_make_jobs = $NUMBER_OF_PROCESSORS
    else
        let g:max_parallel_make_jobs = 4
    endif
endif

" flags are local to buffer
if !exists("b:CFLAGS")
    let b:CFLAGS = "-std=c11 -Wall -Wextra -Wshadow"
    let b:CXXFLAGS = "-std=c++17 -Wall -Wextra -Wold-style-cast -Wshadow"
endif

" settings for vim-fswitch plugin
if exists(":FSHere")
    nnoremap <buffer> <Leader>fs :FSHere<CR>

    augroup fswitch_custom
        autocmd!
        autocmd BufEnter *.h let b:fswitchdst = 'cc,cpp,cxx,tcc,c'
        autocmd BufEnter *.cc,*.cpp,*.cxx,*.tcc let b:fswitchdst = 'h,hpp'

        " give preference to headers in current dir
        autocmd BufEnter *.h let b:fswitchlocs = './,reg:/include/src/,reg:/include.*/src/,ifrel:|/include/|../src|'
        autocmd BufEnter *.c,*.cc,*.cpp,*.cxx,*.tcc let b:fswitchlocs = './,reg:/src/include/,reg:|src|include/**|,ifrel:|/src/|../include|'
    augroup end
endif

if &filetype == "cpp"
    inoremap <buffer> std std::
    inoremap <buffer> ;; ::
endif

" generate ctags for directory of active buffer
nnoremap <buffer> <F11> :call UpdateCtags()<CR>
function! UpdateCtags()
    update
    call PrintSeparator()

    if has("unix")
        if glob("[Mm]akefile") != "" && !empty(system("grep '^tags:' [Mm]akefile"))
            execute '!make -j ' . g:max_parallel_make_jobs . ' tags'
        else
            execute '!ctags -R --c++-kinds=+px --fields=+aiS --extra=+q "%:p:h"'
        endif
    endif
endfunction

" quick compile/run functions
nnoremap <buffer> <F3> :call CompileC()<CR>
function! CompileC()
    update
    call PrintSeparator()

    if glob("[Mm]akefile") != ""
        execute '!make -j ' . g:max_parallel_make_jobs
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
        execute '!make -j ' . g:max_parallel_make_jobs . ' test'
    elseif has("unix") && glob("[Mm]akefile") != "" && !empty(system("grep '^run:' [Mm]akefile"))
        execute '!make -j ' . g:max_parallel_make_jobs . ' run'
    else
        execute '!"%:p:r"'
    endif
endfunction
