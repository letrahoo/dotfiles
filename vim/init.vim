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
set termguicolors " 
" color scheme config
" let g:molokai_original = 1
let g:rehash256 = 1
" colorscheme molokai

" }}}
" Misc {{{

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
" set lazyredraw " redraw only when we need to.
" set showmatch " highlight matching [{()}]
set incsearch " search as characters are enterd
set hlsearch " highlight matches
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

" change leader key to ,
let mapleader=","
" jk is escape
inoremap jk <esc>
" edit vimrc/zshrc and laod vimrc bindings
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" save session
nnoremap <leader>s :mksession<CR>

let g:configFolder = fnamemodify(expand("<sfile>"), ':h:p')
" init plugins
execute 'source' g:configFolder.'/plug.vim'
