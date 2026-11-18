" disable Vi compatible mode
set nocompatible " We're running Vim not Vi!
set notagbsearch

" Init variable
if has('nvim')
  let $VIM_DIRECTORY = $HOME."/.config/nvim"
else
  let $VIM_DIRECTORY = $HOME."/.vim"
endif

set nobackup
set undodir=$VIM_DIRECTORY/undodir

if !isdirectory(&undodir)
  call mkdir(&undodir, 'p', 0700)
endif

" Colors {{{
syntax on " enable syntax processing
set number " show line numbers
set relativenumber " show hybrid line numbers
set background=dark
set termguicolors
" color scheme config
let g:rehash256 = 1

" }}}
" Spaces & Tabs {{{
set tabstop=2 " number of visual spaces per TAB
set softtabstop=2 " number of spaces in tab when editing
set shiftwidth=2
set modelines=1
set expandtab " tabs are spaces
set showcmd " show command in bottom bar
set cursorline " highlight current line
filetype on " Enable filetype detection
filetype indent on " Enable filetype-specific indenting
filetype plugin on " Enable filetype-specific plugins
" }}}
set wildmenu " visual auto complete for command menu
set incsearch " search as characters are entered
set hlsearch " highlight matches
" change leader key to , (must precede <leader> mappings)
let mapleader=","
" turn off search highlight
map <leader>nh :nohlsearch<CR>
set foldenable " enable folding
set foldlevelstart=10 " open most folds by default
set foldmethod=indent " fold based on indent level

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" move to beginning/end of line
nnoremap B ^
nnoremap E $
nnoremap $ <nop>
nnoremap ^ <nop>

" highlight last inserted text
nnoremap gV `[v`]

" jk is escape
inoremap jk <esc>
" edit vimrc/zshrc and load vimrc bindings
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" save session
nnoremap <leader>s :mksession<CR>

let g:configFolder = $VIM_DIRECTORY
" init plugins
execute 'source' g:configFolder.'/plug.vim'
" load custom keymap
if filereadable(g:configFolder.'/keymap.vim')
  execute 'source' g:configFolder.'/keymap.vim'
endif
