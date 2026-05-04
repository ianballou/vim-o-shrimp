" vim-o-shrimp 🦐
" Managed by vim-plug. Deploy with bootstrap.sh

set nocompatible

" --- vim-plug ---
" Auto-install vim-plug if missing
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 install.py' }
Plug 'nvie/vim-flake8'
Plug 'preservim/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rodjek/vim-puppet'

call plug#end()

filetype plugin indent on

" --- Syntastic ---
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_python_python_exec = '/usr/bin/python2.7'
let g:syntastic_quiet_messages = {'level': 'warnings'}

" --- YouCompleteMe ---
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_show_diagnostics_ui = 0
let g:ycm_filetype_specific_completion_to_disable = {
      \ 'ruby': 1
      \}
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" --- Airline ---
let g:airline#extensions#tabline#enabled = 1

" --- NERDTree ---
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" --- Indentation ---
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set noexpandtab
set autoindent

autocmd Filetype ruby set tabstop=2
autocmd Filetype ruby set sw=2
autocmd Filetype ruby set expandtab
autocmd Filetype eruby set tabstop=2
autocmd Filetype eruby set sw=2
autocmd Filetype eruby set expandtab
autocmd Filetype javascript set tabstop=2
autocmd Filetype javascript set sw=2
autocmd Filetype javascript set expandtab

" --- Split navigation ---
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright

" --- Go ---
au BufWritePost *.go !gofmt -w %

" --- Python ---
let g:auto_type_info=0
let python_highlight_all=1

" --- Appearance ---
syntax on
colorscheme elflord
