" vim-plug section
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-commentary'

Plug 'tpope/vim-surround'
"Plug 'vim-airline/vim-airline'
Plug 'itchyny/lightline.vim'

" Use external plugin if lacking native support for match counters
if !has("patch-8.1-1270")
  Plug 'google/vim-searchindex'
endif

Plug 'cespare/vim-toml'

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

" toggle paste mode
nnoremap <leader>p :set paste!<cr>

" Ex mode is retarded
nnoremap Q <Nop>

filetype plugin indent on
syntax enable
set encoding=utf-8
set clipboard=unnamedplus
set number
set mouse=a

set timeout timeoutlen=1000 ttimeoutlen=50

set scrolloff=0

" 80-col line
set cc=80
set nowrap
set textwidth=80
"set ruler

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

set bs=indent,eol,start

set wildmenu

" Use hidden buffers
set hidden

set noswapfile

" colors
set t_Co=256
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

set bg=dark

let g:gruvbox_italic = '1'
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox

" highlight trailing spaces
highlight ExtraWhitespace ctermbg=red guibg=red
let w:m1 = matchadd('ExtraWhitespace', '\s\+\%#\@<!$')
"nnoremap <Leader>wf :call matchdelete(w:m1)<cr>

"nnoremap <Leader>wn :match ExtraWhitespace /\s\+\%#\@<!$/<cr>
"nnoremap <Leader>wf :match<CR>


" Plugin config

let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ }

let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
set nofoldenable  "start with no folds
