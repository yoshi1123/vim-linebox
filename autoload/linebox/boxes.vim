scriptencoding utf-8

" draw box on visual block border
function! linebox#boxes#box() range abort

    " let cols = [col("'<")+getpos("'<")[3], col("'>")+getpos("'>")[3]]
    let cols = [virtcol("'<"), virtcol("'>")]
    let lines = [line("'<"), line("'>")]
    let left = min(cols)
    let right = max(cols)
    let top = min(lines)
    let bot = max(lines)

    for l in range(top, bot)
        let nrcols = strdisplaywidth(getline(l))
        if nrcols < right
            call setline(l, getline(l).repeat(" ", right-nrcols))
        endif
    endfor

    for l in range(top, bot)
        let ltext = getline(l)
        if l == top
            let ltext = substitute(ltext, '\%'.left.'v.', '┌', '')
            let ltext = substitute(ltext, '\%'.right.'v.', '┐', '')
        elseif l == bot
            let ltext = substitute(ltext, '\%'.left.'v.', '└', '')
            let ltext = substitute(ltext, '\%'.right.'v.', '┘', '')
        else
            let ltext = substitute(ltext, '\%'.left.'v.', '│', '')
            let ltext = substitute(ltext, '\%'.right.'v.', '│', '')
        endif
        call setline(l, ltext)
    endfor

    call setline(top, substitute(getline(top), '\%>'.left.'v\%<'.right.'v.', '─', 'g'))
    call setline(bot, substitute(getline(bot), '\%>'.left.'v\%<'.right.'v.', '─', 'g'))

endfunction

" draw blended box on visual block border
function! linebox#boxes#mbox() range abort

    let tlchar = '┌'
    let trchar = '┐'
    let blchar = '└'
    let brchar = '┘'
    let vchar = '│'
    let hchar = '─'

    let cols = [virtcol("'<"), virtcol("'>")]
    let lines = [line("'<"), line("'>")]

    let left = min(cols)
    let right = max(cols)
    let top = min(lines)
    let bot = max(lines)

    let i_left = left-1
    let i_right = right-1
    let i_top = top-1
    let i_bot = bot-1

    for l in range(top, bot)
        let nrcols = strdisplaywidth(getline(l))
        if nrcols < right
            call setline(l, getline(l).repeat(" ", right-nrcols))
        endif
    endfor

    for l in range(top, bot)
        let ltext = getline(l)
        if l == top
            let cur_tl = strcharpart(ltext, i_left, 1)
            let new_tl = get({
                        \ '└': '├',
                        \ '┘': '┼',
                        \ '┌': '┌',
                        \ '┐': '┬',
                        \ '─': '┬',
                        \ '│': '├',
                        \ '┤': '┼',
                        \ '├': '├',
                        \ '┴': '┼',
                        \ '┬': '┬',
                        \ '┼': '┼',
                        \ }, cur_tl, tlchar)
            let cur_tr = strcharpart(ltext, i_right, 1)
            let new_tr = get({
                        \ '┘': '┤',
                        \ '└': '┼',
                        \ '┌': '┬',
                        \ '┐': '┐',
                        \ '─': '┬',
                        \ '│': '┤',
                        \ '┤': '┤',
                        \ '├': '┼',
                        \ '┴': '┼',
                        \ '┬': '┬',
                        \ '┼': '┼',
                        \ }, cur_tr, trchar)
            let ltext = substitute(ltext, '\%'.left.'v.', new_tl, '')
            let ltext = substitute(ltext, '\%'.right.'v.', new_tr, '')
        elseif l == bot
            let cur_bl = strcharpart(ltext, i_left, 1)
            let new_bl = get({
                        \ '┘': '┴',
                        \ '└': '└',
                        \ '┌': '├',
                        \ '┐': '┼',
                        \ '─': '┴',
                        \ '│': '├',
                        \ '┤': '┼',
                        \ '├': '├',
                        \ '┴': '┴',
                        \ '┬': '┼',
                        \ '┼': '┼',
                        \ }, cur_bl, blchar)
            let cur_br = strcharpart(ltext, i_right, 1)
            let new_br = get({
                        \ '┘': '┘',
                        \ '└': '┴',
                        \ '┌': '┼',
                        \ '┐': '┤',
                        \ '─': '┴',
                        \ '│': '┤',
                        \ '┤': '┤',
                        \ '├': '┼',
                        \ '┴': '┴',
                        \ '┬': '┼',
                        \ '┼': '┼',
                        \ }, cur_br, brchar)
            let ltext = substitute(ltext, '\%'.left.'v.', new_bl, '')
            let ltext = substitute(ltext, '\%'.right.'v.', new_br, '')
        else
            let cur_l = strcharpart(ltext, i_left, 1)
            let new_l = get({
                        \ '┘': '┤',
                        \ '└': '├',
                        \ '┌': '├',
                        \ '┐': '┤',
                        \ '─': '┼',
                        \ '│': '│',
                        \ '┤': '┤',
                        \ '├': '├',
                        \ '┴': '┼',
                        \ '┬': '┼',
                        \ '┼': '┼',
                        \ }, cur_l, vchar)
            let cur_r = strcharpart(ltext, i_right, 1)
            let new_r = get({
                        \ '┘': '┤',
                        \ '└': '├',
                        \ '┌': '├',
                        \ '┐': '┤',
                        \ '─': '┼',
                        \ '│': '│',
                        \ '┤': '┤',
                        \ '├': '├',
                        \ '┴': '┼',
                        \ '┬': '┼',
                        \ '┼': '┼',
                        \ }, cur_r, vchar)
            let ltext = substitute(ltext, '\%'.left.'v.', new_l, '')
            let ltext = substitute(ltext, '\%'.right.'v.', new_r, '')
        endif
        call setline(l, ltext)
    endfor

    let ltop = getline(top)
    let new_ltop = ""
    let ltop_list = split(ltop, '\zs')
    for c in ltop_list[i_left+1:i_right-1]
        let cur_t = c
        let new_t = get({
                    \ '┘': '┴',
                    \ '└': '┴',
                    \ '┌': '┬',
                    \ '┐': '┬',
                    \ '─': '─',
                    \ '│': '┼',
                    \ '┤': '┼',
                    \ '├': '┼',
                    \ '┴': '┴',
                    \ '┬': '┬',
                    \ '┼': '┼',
                    \ }, cur_t, hchar)
        let new_ltop .= new_t
    endfor
    call setline(top,
                \ join(ltop_list[0:i_left], "") .
                \ new_ltop .
                \ join(ltop_list[i_right:], ""))

    let lbot = getline(bot)
    let new_lbot = ""
    let lbot_list = split(lbot, '\zs')
    for c in lbot_list[i_left+1:i_right-1]
        let cur_b = c
        let new_b = get({
                    \ '┘': '┴',
                    \ '└': '┴',
                    \ '┌': '┬',
                    \ '┐': '┬',
                    \ '─': '─',
                    \ '│': '┼',
                    \ '┤': '┼',
                    \ '├': '┼',
                    \ '┴': '┴',
                    \ '┬': '┬',
                    \ '┼': '┼',
                    \ }, cur_b, hchar)
        let new_lbot .= new_b
    endfor
    call setline(bot,
                \ join(lbot_list[0:i_left], "") .
                \ new_lbot .
                \ join(lbot_list[i_right:], ""))

endfunction
