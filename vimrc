" vim-plug section
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
"Plug 'vim-airline/vim-airline'
Plug 'itchyny/lightline.vim'

Plug 'plasticboy/vim-markdown'

Plug 'morhetz/gruvbox'

call plug#end()


" use 'jk' for escaping insert mode
inoremap jk <ESC>

" remap leader key(\) to SPACE
"nnoremap <SPACE> <Nop>
"let mapleader = " "

" Clear higlighting
nnoremap \\ :noh<cr>

" toggle list visuals
nmap <leader>l :set list!<CR>
set listchars=tab:▸\ ,eol:¬,space:.

filetype plugin indent on
syntax enable
set encoding=utf-8
set clipboard=unnamedplus
set number
set mouse=a

set ttimeoutlen=50

set scrolloff=0

" 80-col line
"set cc=80
"set nowrap

" indentation with spaces
set expandtab
set shiftwidth=2
set softtabstop=2
set autoindent

" highlight matches
set hlsearch
set incsearch
set ignorecase
set smartcase

"new window will be split below the current one
set splitbelow

" always show the status line
set laststatus=2
" mode is shown in statusline
set noshowmode
" display search counters
set shortmess-=S

" never, ever beep
set belloff=all

" colors
set t_Co=256
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

set bg=dark

let g:gruvbox_italic = '1'
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox
