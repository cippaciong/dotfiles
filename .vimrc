" Basics configuration
filetype off			" Required by vundle
set nocompatible 		" Required by vundle (Be iMproved)
syntax on
set encoding=utf-8
"set spell spellang=en_us	" Set spell checking
set number  			" Display line numbers
set showmatch 			" Highlights matching brackets
set autoindent  		" If you're indented, new lines will also be indented
set smartindent  		" Automatically indents lines after opening a bracket
"set backspace=2  		" This makes the backspace key function like it does in other programs.
set tabstop=4  			" How much space Vim gives to a tab
set shiftwidth=4
"set softtabstop=4
set smarttab  			" Improves tabbing
set expandtab			" Insert space characters whenever the tab key is pressed
set laststatus=2  		" Statusbar always visible for Powerline
set noshowmode 			" Hide the default mode text (e.g. -- INSERT -- below the statusline)
set pastetoggle=<F2>	" Better pasting from external sources

" Aesthetics
colorscheme solarized
set background=dark

" Mappings and shortcuts
" Basics
inoremap jj <ESC>  


" Control shortcuts
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Disable arrow keys in NORMAL mode
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop> 

" Disable arrow keys in VISUAL mode
vnoremap <up> <nop>
vnoremap <down> <nop>
vnoremap <left> <nop>
vnoremap <right> <nop> 

" Powerline
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

""" Vundle """
"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" alternatively, pass a path where Vundle should install bundles
"let path = '~/some/path/here'
"call vundle#rc(path)

" let Vundle manage Vundle, required
Bundle 'gmarik/vundle'

" The following are examples of different formats supported.
" Keep bundle commands between here and filetype plugin indent on.
" scripts on GitHub repos
Bundle 'altercation/vim-colors-solarized'
"Bundle 'tpope/vim-fugitive'
"Bundle 'Lokaltog/vim-powerline'
"Bundle 'Lokaltog/vim-easymotion'
"Bundle 'tpope/vim-rails.git'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
" scripts from http://vim-scripts.org/vim/scripts.html
"Bundle 'L9'
"Bundle 'FuzzyFinder'
" scripts not on GitHub
"Bundle 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Bundle 'file:///home/gmarik/path/to/plugin'
" ...

filetype plugin indent on	" Required by vundle
"
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install (update) bundles
" :BundleSearch(!) foo - search (or refresh cache first) for foo
" :BundleClean(!)      - confirm (or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle commands are not allowed.

""" End Vundle """
