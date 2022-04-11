" linebox - The VIM lines and boxes plugin.
" Copyright (C) 2022  yoshi1@tutanota.com
"
" linebox is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" linebox is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with linebox.  If not, see <https://www.gnu.org/licenses/>.

" Vim global plugin for lines and boxes
" Maintainer:	yoshi1123 <yoshi1@tutanota.com>

if exists('g:loaded_lines')
  finish
endif
let g:loaded_lines = 1

let s:save_cpo = &cpo
set cpo&vim



" PLUGIN BEGIN

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Lines                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

scriptencoding utf-8

function! s:enqueue(o) dict abort
    call insert(self.l, a:o, 0)
endfunction

function! s:dequeue() dict abort
    return remove(self.l, -1)
endfunction

function! s:empty() dict abort
    return len(self.l) == 0
endfunction

function! s:set_char(pos, char) abort
    let pos = a:pos
    let char = a:char
    let line = getline(pos[0])
    let line = substitute(line, '\%'.pos[1].'v.', char, '')
    call setline(pos[0], line)
endfunction

function! s:get_char(pos) abort
    return strcharpart(getline(a:pos[0]), a:pos[1]-1, 1)
endfunction

function! s:is_space(pos) abort
    let char = s:get_char(a:pos)
    return char ==# ' '
endfunction

function! s:edges(pos, goal) abort
    let pos = a:pos
    let goal = a:goal
    let edges = []
    let north = [pos[0]-1, pos[1]]
    let south = [pos[0]+1, pos[1]]
    let west = [pos[0], pos[1]-1]
    let east = [pos[0], pos[1]+1]
    if north[0] >= 1
        if s:is_space(north) || north ==# goal
            call add(edges, north)
        endif
    endif
    if south[0] <= line('$')
        if s:is_space(south) || south ==# goal
            call add(edges, south)
        endif
    endif
    if west[1] >= 1
        if s:is_space(west) || west ==# goal
            call add(edges, west)
        endif
    endif
    if east[1] <= virtcol('$')-1
        if s:is_space(east) || east ==# goal
            call add(edges, east)
        endif
    endif
    return edges
endfunction

function! s:is_edge(p1, p2) abort
    let p1 = a:p1
    let p2 = a:p2
    let north = [p1[0]-1, p1[1]]
    let south = [p1[0]+1, p1[1]]
    let west = [p1[0], p1[1]-1]
    let east = [p1[0], p1[1]+1]
    if index([north,south,west,east], p2) != -1
        return v:true
    else
        return v:false
    endif
endfunction

function! s:get_dir(p1, p2) abort
    let p1 = a:p1
    let p2 = a:p2
    let north = [p1[0]-1, p1[1]]
    let south = [p1[0]+1, p1[1]]
    let west = [p1[0], p1[1]-1]
    let east = [p1[0], p1[1]+1]
    return get({
    \   north[0].','.north[1]: 'north',
    \   south[0].','.south[1]: 'south',
    \   west[0].','.west[1]: 'west',
    \   east[0].','.east[1]: 'east',
    \}, p2[0].','.p2[1], v:null)
endfunction

" param dir         north, south, east, west
" param prev_dir    north, south, east, west
function! s:blend_line(char, dir, prev_dir) abort
    let char = a:char
    let dir = a:dir
    let prev_dir = a:prev_dir
    let new_char = ' '

    """""""""""
    "  North  "
    """""""""""
    if prev_dir ==# '' && dir ==# 'north'
        let new_char = get({
        \   '┘': '┘',
        \   '└': '└',
        \   '┌': '├',
        \   '┐': '┤',
        \   '─': '┴',
        \   '│': '│',
        \   '┤': '┤',
        \   '├': '├',
        \   '┴': '┴',
        \   '┬': '┼',
        \   '┼': '┼',
        \   }, char, '│')
    elseif prev_dir ==# 'north' && dir ==# ''
        let new_char = get({
        \   '┘': '┤',
        \   '└': '├',
        \   '┌': '┌',
        \   '┐': '┐',
        \   '─': '┬',
        \   '│': '│',
        \   '┤': '┤',
        \   '├': '├',
        \   '┴': '┼',
        \   '┬': '┬',
        \   '┼': '┼',
        \   }, char, '│')
    elseif prev_dir ==# 'north' && dir ==# 'north'
        let new_char = get({
        \   '┘': '┤',
        \   '└': '├',
        \   '┌': '├',
        \   '┐': '┤',
        \   '─': '┼',
        \   '│': '│',
        \   '┤': '┤',
        \   '├': '├',
        \   '┴': '┼',
        \   '┬': '┼',
        \   '┼': '┼',
        \   }, char, '│')


    """""""""""
    "  South  "
    """""""""""
    elseif prev_dir ==# '' && dir ==# 'south'
        let new_char = get({
        \   '┘': '┤',
        \   '└': '├',
        \   '┌': '┌',
        \   '┐': '┐',
        \   '─': '┬',
        \   '│': '│',
        \   '┤': '┤',
        \   '├': '├',
        \   '┴': '┼',
        \   '┬': '┬',
        \   '┼': '┼',
        \   }, char, '│')
    elseif prev_dir ==# 'south' && dir ==# ''
        let new_char = get({
        \   '┘': '┘',
        \   '└': '└',
        \   '┌': '├',
        \   '┐': '┤',
        \   '─': '┴',
        \   '│': '│',
        \   '┤': '┤',
        \   '├': '├',
        \   '┴': '┴',
        \   '┬': '┼',
        \   '┼': '┼',
        \   }, char, '│')
    elseif prev_dir ==# 'south' && dir ==# 'south'
        let new_char = get({
        \   '┘': '┤',
        \   '└': '├',
        \   '┌': '├',
        \   '┐': '┤',
        \   '─': '┼',
        \   '│': '│',
        \   '┤': '┤',
        \   '├': '├',
        \   '┴': '┼',
        \   '┬': '┼',
        \   '┼': '┼',
        \   }, char, '│')


    """"""""""
    "  West  "
    """"""""""
    elseif prev_dir ==# '' && dir ==# 'west'
        let new_char = get({
        \   '┘': '┘',
        \   '└': '┴',
        \   '┌': '┬',
        \   '┐': '┐',
        \   '─': '─',
        \   '│': '┤',
        \   '┤': '┤',
        \   '├': '┼',
        \   '┴': '┴',
        \   '┬': '┬',
        \   '┼': '┼',
        \   }, char, '─')
    elseif prev_dir ==# 'west' && dir ==# ''
        let new_char = get({
        \   '┘': '┴',
        \   '└': '└',
        \   '┌': '┌',
        \   '┐': '┬',
        \   '─': '─',
        \   '│': '├',
        \   '┤': '┼',
        \   '├': '├',
        \   '┴': '┴',
        \   '┬': '┬',
        \   '┼': '┼',
        \   }, char, '─')
    elseif prev_dir ==# 'west' && dir ==# 'west'
        let new_char = get({
        \   '┘': '┴',
        \   '└': '┴',
        \   '┌': '┬',
        \   '┐': '┬',
        \   '─': '─',
        \   '│': '┼',
        \   '┤': '┼',
        \   '├': '┼',
        \   '┴': '┴',
        \   '┬': '┬',
        \   '┼': '┼',
        \   }, char, '─')


    """"""""""
    "  East  "
    """"""""""
    elseif prev_dir ==# '' && dir ==# 'east'
        let new_char = get({
        \   '┘': '┴',
        \   '└': '└',
        \   '┌': '┌',
        \   '┐': '┬',
        \   '─': '─',
        \   '│': '├',
        \   '┤': '┼',
        \   '├': '├',
        \   '┴': '┴',
        \   '┬': '┬',
        \   '┼': '┼',
        \   }, char, '─')
    elseif prev_dir ==# 'east' && dir ==# ''
        let new_char = get({
        \   '┘': '┘',
        \   '└': '┴',
        \   '┌': '┬',
        \   '┐': '┐',
        \   '─': '─',
        \   '│': '┤',
        \   '┤': '┤',
        \   '├': '┼',
        \   '┴': '┴',
        \   '┬': '┬',
        \   '┼': '┼',
        \   }, char, '─')
    elseif prev_dir ==# 'east' && dir ==# 'east'
        let new_char = get({
        \   '┘': '┴',
        \   '└': '┴',
        \   '┌': '┬',
        \   '┐': '┬',
        \   '─': '─',
        \   '│': '┼',
        \   '┤': '┼',
        \   '├': '┼',
        \   '┴': '┴',
        \   '┬': '┬',
        \   '┼': '┼',
        \   }, char, '─')


    """""""""""""
    "  Corners  "
    """""""""""""
    elseif prev_dir ==# 'west' && dir ==# 'north'
    \   || prev_dir ==# 'south' && dir ==# 'east'
        let new_char = get({
        \   '┘': '┴',
        \   '└': '┴',
        \   '┌': '├',
        \   '┐': '┼',
        \   '─': '┴',
        \   '│': '├',
        \   '┤': '┼',
        \   '├': '├',
        \   '┴': '┴',
        \   '┬': '┼',
        \   '┼': '┼',
        \   }, char, '└')
    elseif prev_dir ==# 'west' && dir ==# 'south'
    \   || prev_dir ==# 'north' && dir ==# 'east'
        let new_char = get({
        \   '┘': '┼',
        \   '└': '├',
        \   '┌': '┌',
        \   '┐': '┬',
        \   '─': '┬',
        \   '│': '├',
        \   '┤': '┼',
        \   '├': '├',
        \   '┴': '┼',
        \   '┬': '┬',
        \   '┼': '┼',
        \   }, char, '┌')
    elseif prev_dir ==# 'north' && dir ==# 'west'
    \   || prev_dir ==# 'east' && dir ==# 'south'
        let new_char = get({
        \   '┘': '┤',
        \   '└': '┼',
        \   '┌': '┬',
        \   '┐': '┐',
        \   '─': '┬',
        \   '│': '┤',
        \   '┤': '┤',
        \   '├': '┼',
        \   '┴': '┼',
        \   '┬': '┬',
        \   '┼': '┼',
        \   }, char, '┐')
    elseif prev_dir ==# 'east' && dir ==# 'north'
    \   || prev_dir ==# 'south' && dir ==# 'west'
        let new_char = get({
        \   '┘': '┘',
        \   '└': '┴',
        \   '┌': '┼',
        \   '┐': '┤',
        \   '─': '┴',
        \   '│': '┤',
        \   '┤': '┤',
        \   '├': '┼',
        \   '┴': '┴',
        \   '┬': '┼',
        \   '┼': '┼',
        \   }, char, '┘')

    endif
    return new_char
endfunction

function! s:write_path(path) abort
    let path = a:path
    let i = 0
    let prev_dir = ''
    for pos in path
        let char = s:get_char(pos)

        if i == len(path)-1
            let next = v:null
        else
            let next = path[i+1]
        endif

        if next isnot# v:null
            let dir = s:get_dir(pos, next)
            let new_char = s:blend_line(char, dir, prev_dir)
            call s:set_char(pos, new_char)
            if ! g:linebox_animation
                redraw!
                sleep 30m
            endif
            let prev_dir = dir
        else
            let dir = ''
            let new_char = s:blend_line(char, dir, prev_dir)
            call s:set_char(pos, new_char)
        endif

        let i += 1
    endfor
endfunction

" Return shortest path via breadth first search.
function! s:find_path_bf(root, goal) abort
    " pos = [line,col]
    let root = a:root
    let goal = a:goal

    let q = {'l': [], 'enqueue': function('s:enqueue'),
    \   'dequeue': function('s:dequeue'), 'empty': function('s:empty')}
    let explored = []
    call add(explored, root)
    call q.enqueue(root)
    let prev = {}

    while ! q.empty()

        let v = q.dequeue()

        if v == goal
            let path = []
            let p = v
            call add(path, p)
            while p != root
                let p = prev[p[0].','.p[1]]
                call add(path, p)
            endwhile
            return reverse(path)
        endif

        let edges = s:edges(v, goal)
        for edge in edges
            if index(explored, edge) == -1
                " edge not explored
                call add(explored, edge)
                call q.enqueue(edge)
                let prev[edge[0].','.edge[1]] = v
            endif
        endfor
    endwhile
    return v:null
endfunction

" Draws a line from start to end.
"
" Parameters can either be
"   marks of the start and end, e.g. 'a and 'b,
"   or postions of the start and end, e.g. [line,col].
function! Line(start, end) abort
    if type(a:start) != 3 && type(a:end) != 3
        if type(a:start) == 1 && len(a:start)>0 && type(a:end) == 1 && len(a:end)>0
            let start = getcharpos(a:start)[1:2]
            let end = getcharpos(a:end)[1:2]
        else
            echoerr 'lines:arguments are not positions'
            return
        endif
    else
        let start = a:start
        let end = a:end
    endif
    let path = s:find_path_bf(start, end)
    if path is v:null
        echoerr 'lines: could find path'
        return
    endif
    call s:write_path(path)
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Settings                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:linebox_default_maps = get(g:, 'linebox_default_maps', 0)
let g:linebox_marks = get(g:, 'linebox_marks', ["'a", "'b"])
let g:linebox_animation = get(g:, 'linebox_animation', 1)


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Mappings                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if g:linebox_default_maps
    nnoremap <leader>L :call Line(g:linebox_marks[0], g:linebox_marks[1])<cr>
endif

" PLUGIN END



let &cpo = s:save_cpo
unlet s:save_cpo
