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
    nnoremap <leader>L :call linebox#lines#line(g:linebox_marks[0], g:linebox_marks[1])<cr>
endif

" PLUGIN END



let &cpo = s:save_cpo
unlet s:save_cpo
