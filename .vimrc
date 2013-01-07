"---------------------------------------------------------------
" file:     ~/.vimrc                         
" author:   jason ryan - http://jasonwryan.com/    
" vim:fenc=utf-8:nu:ai:si:et:ts=4:sw=4:fdm=indent:fdn=1:ft=vim:
"---------------------------------------------------------------

map ; :
syntax on
"filetype plugin on
"filetype indent on

if &t_Co < 256
    colorscheme miro8   " colourscheme for the 8 colour linux term
else
    colorscheme mustang
endif

"------------------------------------------------------------------------------------------------------------------
"---- Source: http://www.techerator.com/2010/11/the-ultimate-vimrc-configuration-file-for-the-vim-text-editor/ ----
"------------------------------------------------------------------------------------------------------------------

"set nocompatible "This fixes the problem where arrow keys do not function properly on some systems.
set mouse=a  "Allows you to click around the text editor with your mouse to move the cursor
set showmatch "Highlights matching brackets in programming languages
set autoindent  "If you're indented, new lines will also be indented
set smartindent  "Automatically indents lines after opening a bracket in programming languages
"set backspace=2  "This makes the backspace key function like it does in other programs.
set tabstop=4  "How much space Vim gives to a tab
set number  "Enables line numbering
set smarttab  "Improves tabbing
set pastetoggle=<F2>
"set shiftwidth=4  "Assists code formatting
"colorscheme darkblue  "Changes the color scheme. Change this to your liking. Lookin /usr/share/vim/vim61/colors/ for options.
"setlocal spell  "Enables spell checking (CURRENTLY DISABLED because it's kinda annoying). Make sure to uncomment the next line if you use this.
"set spellfile=~/.vimwords.add  "The location of the spellcheck dictionary. Uncomment this line if you uncomment the previous line.
"set foldmethod=manual  "Lets you hide sections of code
"--- The following commands make the navigation keys work like standard editors
"imap <silent> <Down> <C-o>gj
"imap <silent> <Up> <C-o>gk
"nmap <silent> <Down> gj
"nmap <silent> <Up> gk
"--- Ends navigation commands
"--- The following adds a sweet menu, press F4 to use it.
"source $VIMRUNTIME/menu.vim
"set wildmenu
"set cpo-=<
"set wcm=<C-Z>
"map <F4> :emenu <C-Z>
"--- End sweet menu
