vim-linebox -- the VIM lines and boxes plugin.

## Bugs

**NOTE: If you find a bug, please file an issue.**

## Demo

[demo](doc/vim-linebox-demo.gif)

## Features

- Draw boxes with `<leader>b`
- Draw blended boxes with `<leader>B`
- Draw lines with `<leader>L`

## Installation

Use your plugin manager of choice. On Windows, replace the directory `~/.vim`
with `~/vimfiles`.

- Vim Packages
    - Linux/Unix/OSX:
        - `git clone --recursive https://github.com/yoshi1123/vim-linebox ~/.vim/pack/bundle/start/vim-linebox`
      - Run `:helptags ~/.vim/pack/bundle/start/vim-linebox/doc`
    - Windows:
        - `git clone --recursive https://github.com/yoshi1123/vim-linebox ~/vimfiles/pack/bundle/start/vim-linebox`
      - Run `:helptags ~/vimfiles/pack/bundle/start/vim-linebox/doc`
- [Pathogen](https://github.com/tpope/vim-pathogen)
  - Linux/Unix/OSX:
      - `git clone --recursive https://github.com/yoshi1123/vim-linebox ~/.vim/bundle/vim-linebox`
  - Windows:
      - `git clone --recursive https://github.com/yoshi1123/vim-linebox ~/.vim/bundle/vim-linebox`
- [Vundle](https://github.com/gmarik/vundle)
  - Add `Bundle 'https://github.com/yoshi1123/vim-linebox'` to .vimrc
  - Run `:BundleInstall`
- [NeoBundle](https://github.com/Shougo/neobundle.vim)
  - Add `NeoBundle 'https://github.com/yoshi1123/vim-linebox'` to .vimrc
  - Run `:NeoBundleInstall`
- [vim-plug](https://github.com/junegunn/vim-plug)
  - Add `Plug 'https://github.com/yoshi1123/vim-linebox'` to .vimrc
  - Run `:PlugInstall`

## Quick start


Add `let g:linebox_default_maps = 1` to your vimrc (see "Default mappings"
below).


**Boxes**:

Use visual mode to select a rectable, and make a box with `<leader>b`.

Use visual mode to select a rectable, and make a box with `<leader>B` to blend
with other lines.

`<leader>b` vs `<leaderB`:
```
    <leader>b   <leader>B
 
     │  │  │     │  │  │
    ┌───────┐   ┌┼──┼──┼┐
    ││  │  ││   ││  │  ││
    └───────┘   └┼──┼──┼┘
     │  │  │     │  │  │
```

**Lines**:

Make a start and end mark with marks \`a and \`b. Then draw a line with
`<leader>L`.

NOTE: There must be a path of whitespace from mark a to mark b.

## Default Settings

```
let g:linebox_default_maps = 0
let g:linebox_marks = ["'a", "'b"]
let g:linebox_animation = 1
```

## Default mappings

    nnoremap <leader>L :call Line("'a", "'b")<cr>
    nnoremap <leader>b :call Box()<cr>
    vnoremap <leader>b :call Box()<cr>
    nnoremap <leader>B :call MBox()<cr>
    vnoremap <leader>B :call MBox()<cr>

## Documentation

In Vim:

    :help vim-linebox
