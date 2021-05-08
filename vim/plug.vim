" vim-plug management
call plug#begin(g:configFolder.'/plugged')
Plug 'kien/ctrlp.vim' " quick find file plugin
" CtrlP settings

let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'
" let g:ctrlp_user_command = 'ag %s -l --nocolor -hidden -g ""'

Plug 'mileszs/ack.vim' " quick find content in directory plugin
" Ack/Ag settings
noremap <leader>a :Ack!<Space>
if executable('ag')
  let g:ackprg = 'ag --vimgrep --nogroup --column'
endif
" highlight seaching keyword
let g:ackhighlight = 1

" tmux integration
Plug 'christoomey/vim-tmux-navigator'
" Application
Plug 'scrooloose/nerdtree'
let g:NERDSpaceDelims = 1
let g:NERDTreeShowHidden=1
let NERDTreeIgnore = ['^.git$']
" t - NERDTree
map <silent> <leader>tt :NERDTreeToggle<cr>
map <silent> <leader>tm :NERDTreeMirrow<cr> 
map <silent> <leader>tj :NERDTreeFind<cr> 
map <silent> <leader>tf :NERDTreeFocus<cr>
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Plug 'NLKNguyen/papercolor-theme' " papercolor theme
Plug 'dracula/vim'

" language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'wting/rust.vim' " rust language support plugin
Plug 'vim-ruby/vim-ruby' " ruby language support plugin
Plug 'elzr/vim-json' " json syntax highlight
Plug 'leafgarland/typescript-vim'
Plug 'ianks/vim-tsx'
Plug 'w0rp/ale'
let g:ale_linters = {
			\'typescript': ['tslint']
      \}
let g:ale_fixers = {
      \'javascript': [
			\	'prettier'
			\],
      \'typescript': ['tslint', 'prettier'],
			\'json': ['prettier'],
			\'json5': ['prettier'],
      \'css': ['stylelint', 'prettier'],
      \'less': ['stylelint', 'prettier'],
			\'vue': ['prettier'],
			\}
let g:ale_fix_on_save = 1

" UI
Plug 'luochen1990/rainbow' " rainbow parentheses
let g:rainbow_active = 1

Plug 'vim-airline/vim-airline' " vim status airline
Plug 'vim-airline/vim-airline-themes' " ariline theme
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#enabled = 1
" let g:airline_section_b = '%{strftime("%H:%M")}'
let g:airline_theme='fruit_punch'

Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" wakatime data tracing
Plug 'wakatime/vim-wakatime'
call plug#end()

colorscheme dracula
