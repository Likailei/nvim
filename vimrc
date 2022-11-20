set nocompatible

syntax on
set nu
set wildmenu
set guifont=JetBrains\ Mono:h14

set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

set backspace=indent,eol,start

set incsearch
set smartcase
set hlsearch

nnoremap * :keepjumps normal! mi*`i<CR>

" hight spaces at end of line
highlight WhiteSpaceEOL ctermbg=darkgreen guibg=lightgreen
match WhiteSpaceEOL /\s$/
autocmd WinEnter * match WhiteSpaceEOL /\s$/
