" Temporary until `getcharpos()`'s fix (patch 8.2.4734) is installed more.
function! linebox#getcharpos(expr) abort
    let pos = getpos(a:expr)
    let pos[2] = charidx(getline(pos[1]), pos[2]-1)+1
    return pos
endfunction
