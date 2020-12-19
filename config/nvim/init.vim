" vim: fdm=marker foldenable sw=4 ts=4 sts=4

" {{{ Plugins
"
call plug#begin('~/.local/share/nvim/plugged')

" Autocompletion and LSP
Plug 'Shougo/deoplete.nvim', {
    \ 'do': ':UpdateRemotePlugins'}
    "\ 'tag': '5.2' }
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" Interface
Plug '/usr/share/vim/vimfiles/plugin'       " Load fzf
Plug 'junegunn/fzf.vim'
Plug 'blueyed/vim-diminactive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'easymotion/vim-easymotion'
Plug 'preservim/tagbar', { 'do': ':helptags' }
Plug 'wincent/loupe'

" Folding
Plug 'Konfekt/FastFold'     " Faster folding engine
Plug 'tmhedberg/SimpylFold' " Python
Plug 'matze/vim-tex-fold'   " LaTeX

" Editing
"Plug 'dense-analysis/ale'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'JamshedVesuna/vim-markdown-preview'

" Writing
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

"Themes
Plug 'arcticicestudio/nord-vim'

""" Languages
Plug 'pearofducks/ansible-vim'                          " Ansible
Plug 'rhysd/vim-crystal'                                " Crystal
Plug 'elixir-editors/vim-elixir'                        " Elixir
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }     " Go
Plug 'pangloss/vim-javascript'                          " Javascript
Plug 'google/vim-jsonnet'                               " Jsonnet
Plug 'lervag/vimtex'                                    " LaTeX
Plug 'hashivim/vim-terraform'                           " Terraform
Plug 'leafgarland/typescript-vim'                       " Typescript

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
set colorcolumn=80
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

""" Deoplete
let g:deoplete#enable_at_startup = 1 " Enable deoplete
call deoplete#custom#option('smart_case', v:true) " Use smartcase.
" Disable signature scratch buffer
set completeopt-=preview


""" LanguageClient-neovim
let g:LanguageClient_serverCommands = {
    \ 'elixir':     ['/usr/bin/elixir-ls'],
    \ 'go':     ['/usr/bin/gopls'],
    \ 'python': ['/usr/bin/pyls'],
    \ 'ruby':   ['/usr/bin/solargraph', 'stdio'],
    \ }
" Disable inline linting messages
let g:LanguageClient_useVirtualText = "No"
" Disable linting completely
"let g:LanguageClient_diagnosticsEnable = 0
nnoremap <leader>,e :call LanguageClient#explainErrorAtPoint()<CR>
nnoremap <leader>,d :call LanguageClient#textDocument_definition()<CR>
nnoremap <leader>,i :call LanguageClient#textDocument_implementation()<CR>
nnoremap <leader>,r :call LanguageClient#textDocument_rename()<CR>
nnoremap <leader>,f :call LanguageClient#textDocument_formatting()<CR>
nnoremap <leader>,t :call LanguageClient#textDocument_typeDefinition()<CR>
nnoremap <leader>,x :call LanguageClient#textDocument_references()<CR>
nnoremap <leader>,a :call LanguageClient_workspace_applyEdit()<CR>
nnoremap <leader>,c :call LanguageClient#textDocument_completion()<CR>
nnoremap <leader>,h :call LanguageClient#textDocument_hover()<CR>
nnoremap <leader>,s :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <leader>,m :call LanguageClient_contextMenu()<CR>


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


""" Ansible
let g:ansible_template_syntaxes = { '*.rb.j2': 'ruby', '*.y.?ml.j2': 'yaml' }


""" Terraform
let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_commentstring='//%s'
let g:terraform_fmt_on_save=1


""" vim-markdown-preview
let vim_markdown_preview_github=1
let vim_markdown_preview_browser='Firefox'


""" vimtex
let g:tex_flavor  = 'latex'
let g:tex_conceal = ''
let g:vimtex_fold_manual = 1
let g:vimtex_latexmk_continuous = 1
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_quickfix_latexlog = {'default' : 0}
" Deoplete integration
call deoplete#custom#var('omni', 'input_patterns', {
      \ 'tex': g:vimtex#re#deoplete
      \})


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


""" Limelight
" color for dimming down the surrounding paragraphs
let g:limelight_conceal_ctermfg = 'gray'


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
