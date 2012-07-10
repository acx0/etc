" functions used by other ftplugins

function! PrintSeparator()
    if has("win32")
        return
    endif

    if !exists("b:separator")
        let b:separator = "line"
    endif

    if b:separator == "line"
        let s:sep = "\\n\\n" . repeat("=", &columns / 2)
        execute 'silent !echo -ne "' . s:sep . '"'
    elseif b:separator == "clear"
        silent !clear
    endif
endfunction
