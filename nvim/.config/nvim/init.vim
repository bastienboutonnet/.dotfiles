call plug#begin('~/.vim/plugged')

"Plug 'rmehri01/onenord.nvim', { 'branch': 'main' }
" Make sure you use single quotes
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fannheyward/coc-pyright', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tabnine', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
"Plug 'terryma/vim-multiple-cursors'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'machakann/vim-highlightedyank'
"Plug 'lifepillar/vim-gruvbox8'
"Plug 'tmhedberg/SimpylFold'
"Plug 'joshdick/onedark.vim'
"Plug 'morhetz/gruvbox'
"Plug 'rakr/vim-one'
"Plug 'junegunn/seoul256.vim'
Plug 'sheerun/vim-polyglot'
"Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build' }
Plug 'tpope/vim-fugitive'
"Plug 'davidhalter/jedi-vim'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'
Plug 'ntpeters/vim-better-whitespace'
Plug 'heavenshell/vim-pydocstring', { 'do': 'make install' }
Plug 'jeffkreeftmeijer/vim-numbertoggle'
"Plug 'airblade/vim-gitgutter'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'BurntSushi/ripgrep'
"Plug 'bling/vim-bufferline'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
"Plug 'tiagovla/tokyodark.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'neovim/nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'ryanoasis/vim-devicons'
Plug 'nvim-lua/popup.nvim'
Plug 'ThePrimeagen/harpoon'
Plug 'navarasu/onedark.nvim'
"Plug 'crispgm/nvim-tabline'
Plug 'kyazdani42/nvim-web-devicons' " Recommended (for coloured icons)
" Plug 'ryanoasis/vim-devicons' Icons without colours
Plug 'akinsho/bufferline.nvim'
"Initialize plugin system
call plug#end()

"Load the lua modules for plugin which have their settings in lua files
lua require("datafrittata")

" Treesitter
lua require'nvim-treesitter.configs'.setup {ensure_installed = {"python"}, highlight = {enable = true, disable = {"yaml"}}}

" Rando shit that I don't really know where to put
set encoding=UTF-8
let g:airline#extensions#bufferline#enabled = 0
let g:NERDTreeShowHidden=1
let g:pydocstring_formatter = 'google'
let g:python3_host_prog="~/venvs/neovim/bin/python"
" Align GitHub-flavored Markdown tables
au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>

" Toggle between buffers
nmap <Leader>bn :bn<CR>
nmap <Leader>bp :bp<CR>
nnoremap <C-p> :Rg<Cr>
nnoremap <C-e> :Files<Cr>
nmap <Leader>bl :Buffers<CR>
nmap <Leader>g :GFiles<CR>
nmap <Leader>e :Files<CR>
"nmap <Leader>p :Rg<CR>
nmap <Leader>g? :GFiles?<CR>
nmap <Leader>h :History<CR>

"Load coc settings
" TODO: I need to check whether I can get rid of coc one day
runtime coc-init.vim

"# Themes and Look related stuff
let g:airline_powerline_fonts = 1
let g:airline_theme='deus'
"for yank
hi HighlightedyankRegion cterm=reverse gui=reverse
syntax on
let g:onedark_style = 'darker'
colorscheme onedark

" Settings START
let mapleader = ","
filetype plugin on
set completeopt=menuone
set mouse=a
set nobackup
set nocompatible
set noswapfile
set nowritebackup
set number
set signcolumn=yes
set title
set nowrap
setlocal wrap
set termguicolors
set cursorline
set hidden
set cmdheight=1
set laststatus=2
set list
set listchars=tab:»·,trail:·
set completeopt-=preview


" persist START
set undofile " Maintain undo history between sessions
set undodir=~/.vim/undodir

" Persist cursor
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif
" persist END
"------------------------------------------------

" use omni completion provided by lsp
autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc


