" Minimal neovim config - vim-friendly with modern features
" This keeps your vim muscle memory while adding useful neovim features

" ============================================
" Basic Settings (works like vim)
" ============================================
set number                     " Show line numbers
set relativenumber             " Relative line numbers
set expandtab                  " Spaces instead of tabs
set shiftwidth=4               " 4 spaces for indent
set tabstop=4                  " 4 spaces for tab
set softtabstop=4
set autoindent                 " Copy indent from current line
set smartindent                " Smart autoindenting
set mouse=a                    " Enable mouse
set clipboard+=unnamedplus     " Use system clipboard
set ignorecase                 " Case insensitive search
set smartcase                  " ...unless uppercase used
set incsearch                  " Incremental search
set hlsearch                   " Highlight search results
set scrolloff=8                " Keep 8 lines above/below cursor
set signcolumn=yes             " Always show sign column
set updatetime=250             " Faster completion
set timeoutlen=300             " Faster key sequence completion
set splitright                 " Split windows to the right
set splitbelow                 " Split windows below
set hidden                     " Allow hidden buffers
set nowrap                     " Don't wrap lines
set cursorline                 " Highlight current line
set termguicolors              " Enable 24-bit colors
syntax on
filetype plugin indent on

" ============================================
" Leader key (space is easy to reach)
" ============================================
let mapleader = " "

" ============================================
" Essential keymaps (vim-style)
" ============================================
" Clear search highlight with Escape
nnoremap <Esc> :nohlsearch<CR>

" Quick save
nnoremap <leader>w :w<CR>

" Quick quit
nnoremap <leader>q :q<CR>

" Better window navigation (Ctrl+hjkl)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize windows with arrows
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Move lines up/down in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Stay in visual mode when indenting
vnoremap < <gv
vnoremap > >gv

" Quick buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" ============================================
" File explorer (netrw - built in)
" ============================================
" Toggle with <leader>e
nnoremap <leader>e :Lexplore 25<CR>

let g:netrw_banner = 0         " Hide banner
let g:netrw_liststyle = 3      " Tree view
let g:netrw_browse_split = 4   " Open in prior window
let g:netrw_winsize = 25       " 25% width

" ============================================
" Python-specific settings
" ============================================
autocmd FileType python setlocal shiftwidth=4 tabstop=4

" ============================================
" Quick terminal
" ============================================
nnoremap <leader>t :split<CR>:terminal<CR>:resize 15<CR>i

" Exit terminal mode with Escape
tnoremap <Esc> <C-\><C-n>

" ============================================
" Colors (use built-in colorschemes)
" ============================================
" Try these colorschemes (included with neovim):
" :colorscheme desert
" :colorscheme slate
" :colorscheme industry

" Default to something readable
silent! colorscheme slate
