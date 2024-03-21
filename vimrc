set nocompatible

syntax on
set nu
set wildmenu
set guifont=JetBrains\ Mono:h12:cANSI:qDRAFT

set expandtab
set tabstop=4
set softtabstop=-1
set shiftwidth=4
set backspace=indent,eol,start
set numberwidth=4

set incsearch
set smartcase
set hlsearch

nnoremap * :keepjumps normal! mi*`i<CR>

set guioptions-=T "remove toolbar
set guioptions-=m "remove menu bar
set guioptions-=r "remove right scroll bar
set guioptions-=L "remove right scroll bar

let mapleader = ","
nmap <leader>e :e $HOME\_vimrc<CR>
nmap <leader>s :source $HOME\_vimrc<CR>
nmap <leader>q :q<CR>
nmap <leader>w :wq<CR>

noremap <F1> :NERDTreeToggle<CR>
noremap <M-j> :resize +5<CR>
noremap <M-k> :resize -5<CR>
noremap <M-h> :vertical resize -5<CR>
noremap <M-l> :vertical resize +5<CR>

noremap <C-j> ddp
noremap <C-k> ddP

if(has("termguicolors"))
  set termguicolors
endif

call plug#begin()
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'haishanh/night-owl.vim'
call plug#end()

" hight spaces at end of line
highlight WhiteSpaceEOL ctermbg=darkgreen guibg=lightgreen
match WhiteSpaceEOL /\s$/
autocmd WinEnter * match WhiteSpaceEOL /\s$/
