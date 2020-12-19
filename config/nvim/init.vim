" vim: fdm=marker foldenable sw=4 ts=4 sts=4

" {{{ Plugins
"
call plug#begin('~/.local/share/nvim/plugged')

" Autocompletion and LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}         " LSP support
Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}    " Elixir extention for coc.nvim

" Editing
Plug 'preservim/nerdcommenter'                          " Easily comment code
Plug 'tpope/vim-surround'                               " Easily surround text blocks

" Folding
Plug 'Konfekt/FastFold'                                 " Faster folding engine
Plug 'tmhedberg/SimpylFold'                             " Python folding
Plug 'matze/vim-tex-fold'                               " LaTeX folding

" Interface
Plug 'arcticicestudio/nord-vim'                         " Nord theme
Plug 'blueyed/vim-diminactive'                          " Dim inactive windows
Plug 'vim-airline/vim-airline'                          " Airline statusbar
Plug 'vim-airline/vim-airline-themes'                   " Airline themes
Plug 'wincent/loupe'                                    " Syntax highlighting for searched patterns

""" Languages
Plug 'elixir-editors/vim-elixir'                        " Elixir
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }     " Go
Plug 'google/vim-jsonnet'                               " Jsonnet
Plug 'lervag/vimtex'                                    " LaTeX
Plug 'hashivim/vim-terraform'                           " Terraform

" Navigation
Plug '/usr/share/vim/vimfiles/plugin'                   " Load fzf
Plug 'junegunn/fzf.vim'                                 " fzf integration
Plug 'easymotion/vim-easymotion'                        " Easier vim navigation across text
Plug 'preservim/nerdtree'                               " Tree file explorer
Plug 'preservim/tagbar', { 'do': ':helptags' }          " Sidebar for code navigation
Plug 'tpope/vim-unimpaired'                             " Handy bracket mappings
Plug 'tpope/vim-repeat'                                 " Enable repeating supported plugin maps with '.'

" Snippets
Plug 'SirVer/ultisnips'                                 " Generate code using snippets
Plug 'honza/vim-snippets'                               " Snippets repository for UltiSnips

call plug#end()
" }}}

" {{{ Configuration

" Enable syntax highlighting
syntax on

" Enable Omni completion for smart autocompletion
filetype plugin on
set omnifunc=syntaxcomplete#Complete

let mapleader=","
set hidden
set number
set relativenumber
set colorcolumn=120
" Use 4 spaces indentation and replace tabs with spaces
set shiftwidth=4
let &softtabstop = &shiftwidth
set expandtab
" Smartly indent code based on the language in use
set autoindent
set smartindent
" Enable the wildmenu for better filename completion
set wildmenu
" Look for files in the current directory and its subdirectories
set path=.,**

" Hide mode information (INSERT, VISUAL, etc.)
set noshowmode

" Toggle paste mode
set pastetoggle=<F2>

" Enable mouse support
set mouse=a

" Colorscheme
"let base16colorspace=256  " Access colors present in 256 colorspace
if $TERM =~ '^\(rxvt\|screen\|interix\|putty\)\(-.*\)\?$'
    set notermguicolors
elseif $TERM =~ '^\(tmux\|iterm\|vte\|gnome\)\(-.*\)\?$'
    set termguicolors
elseif $TERM =~ '^\(xterm\)\(-.*\)\?$'
    if $XTERM_VERSION != ''
        set termguicolors
    elseif $KONSOLE_PROFILE_NAME != ''
        set termguicolors
    elseif $VTE_VERSION != ''
        set termguicolors
    else
        set notermguicolors
    endif
endif
colorscheme nord
" Custom search highlighting
hi Search ctermfg=18 ctermbg=3 guifg=#B48EAD guibg=NONE gui=bold,underline

" }}}

" {{{ Plugins config

""" vim-go
" Enable additional vim-go syntax highlighting
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
" Enable highlighting of variables that are the same (disabled to save battery)
" WARN: This two options might cause battery drain and slow down vim if enabled
let g:go_fmt_command = "goimports"
let g:go_auto_sameids = 0
let g:go_auto_type_info = 0


""" Terraform
let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_commentstring='//%s'
let g:terraform_fmt_on_save=1


""" vimtex
let g:tex_flavor  = 'latex'
let g:tex_conceal = ''
let g:vimtex_fold_manual = 1
let g:vimtex_latexmk_continuous = 1
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_quickfix_latexlog = {'default' : 0}


""" Utilsnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"


""" NERDTree
let g:NERDTreeWinSize=40


""" NERDCommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'


""" Airline
let g:airline_theme='nord'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep=''
let g:airline_right_sep=''


""" vim-diminactive
" Remove nofile from the blacklist to enable diminactive in NERDTree and
" Tagbar buffers
let g:diminactive_buftype_blacklist = ['nowrite', 'acwrite', 'quickfix', 'help']

" }}}

" {{{ Mappings

" Close buffer without closing split
nnoremap <leader>d :bp\|bd #<CR>

" fzf
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>a :Ag<CR>
nnoremap <leader>A :Agi<CR>
nnoremap <leader>h :History<CR>
nnoremap <Leader>l :BLines<CR>
nnoremap <Leader>L :Lines<CR>
nnoremap <Leader>C :Commands<CR>

" nvim-typescript
nnoremap <leader>tsg :TSDef<CR>

" vim-go
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>t <Plug>(go-test)

" Clear the search highlighting
nnoremap <Leader>c :nohlsearch<CR>

" Easier split navigations
" Instead of ctrl-w then j, it’s just ctrl-j
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Same as above using arrows
nnoremap <C-left> <C-w>h
nnoremap <C-down> <C-w>j
nnoremap <C-up> <C-w>k
nnoremap <C-right> <C-w>l

" Toggle NERDTree and Tagbar
nmap <F7> :NERDTreeToggle<CR>
nmap <F8> :TagbarToggle<CR>

" }}}

" {{{ Spell Check
"
set spelllang=en_gb
set complete+=kspell    " Dictionary word completion

" LaTeX
autocmd FileType tex setlocal spell

" Markdown
autocmd FileType markdown setlocal spell

" .txt
autocmd BufRead,BufNewFile *.txt setlocal spell

" Git Commit
autocmd FileType gitcommit setlocal spell

" }}}
