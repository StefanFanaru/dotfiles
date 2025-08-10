" Set environment variable for dot files

" Enable line numbers
set number
set relativenumber

" Set tab and indentation options
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

" Disable line wrapping
set nowrap

" Enable swapfile and undofile
set swapfile
set undofile

" Enable search highlighting and incremental searching
set hlsearch
set incsearch

" Enable true color support
set termguicolors

" Set scroll offset and sign column
set scrolloff=8
set signcolumn=yes

" Set update time and timeout length
set updatetime=50
set timeoutlen=500


" Set leader key
let mapleader = " "

" Bind Space + f to execute :Files
nnoremap <leader>f :Files<CR>

" Copy to system clipboard using Space + Y
vnoremap <leader>y <Plug>OSCYankVisual

" Netrw settings
let g:netrw_browse_split = 0
let g:netrw_banner = 0
let g:netrw_winsize = 25

" Set nerd font variable
set showmode
set ruler

" Ignore case when searching
set ignorecase
set smartcase

" Split windows to the right
set splitright

" Enable smooth scrolling
set smoothscroll


"############# REMAPS ############
" Show Netrw directory listing when pressing \ twice
nnoremap \\ :Ex<CR>
nnoremap <leader>sf :Files<CR>

" Move lines when they are visually selected
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv


" Add new empty lines
nnoremap <CR> o<ESC>

" Keep cursor in place
nnoremap J mzJ`z
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" When pasting over, preserve initial yanked value
xnoremap <leader>p "_dP " Paste while keeping registry

" Make C-c work in visual block
inoremap <C-c> <Esc>

" Search and replace
nnoremap <leader>* :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left> " Search and replace current word

" Map q: to :q
nnoremap q: <nop> " This line is commented out because it doesn't have a direct equivalent

" Exit terminal mode easier
tnoremap <Esc><Esc> <C-\><C-n> " Exit terminal mode

" Exit hlsearch
nnoremap <Esc><Esc> :nohlsearch<CR>

" Keybinds to make split navigation easier.
" Use CTRL+<hjkl> to switch between windows
nnoremap <C-h> <C-w>h " Move focus to the left window
nnoremap <C-l> <C-w>l " Move focus to the right window
nnoremap <C-j> <C-w>j " Move focus to the lower window
nnoremap <C-k> <C-w>k " Move focus to the upper window

" The max column line that appears on <leader>1 will be grey

" ############## PLUGINS #############
" Check if vim-plug is installed, if not, install it
if !filereadable(expand('~/.vim/autoload/plug.vim'))
  silent! execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs ' .
        \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif
call plug#begin('~/.vim/plugged')

" List of plugins
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sensible'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'sheerun/vim-polyglot'
Plug 'ojroques/vim-oscyank', {'branch': 'main'}

call plug#end()

function ApplyPluginsConfig()
    let g:lightline = {'colorscheme': 'catppuccin_mocha'}
    syntax on
    colorscheme catppuccin_mocha
    highlight Normal ctermbg=NONE guibg=NONE " Set normal background to transparent
    highlight SignColumn guibg=black ctermbg=black
    let g:airline_section_y = ''
    let g:airline_section_z = ''
    let g:airline#extensions#whitespace#enabled = 0
    let g:oscyank_max_length = 0
endfunction

" Auto-install plugins if they are not already installed
if empty(glob('~/.vim/plugged/*'))
  " Check if any plugins are missing and install them
  silent! execute 'PlugInstall'
  call ApplyPluginsConfig()
  execute 'q!'
else
  call ApplyPluginsConfig()
endif

