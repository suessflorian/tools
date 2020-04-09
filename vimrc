let mapleader = " "

call plug#begin('~/.config/nvim/plugged')
    Plug 'https://github.com/junegunn/fzf.vim'
    Plug 'https://github.com/ruanyl/vim-gh-line'
    Plug 'https://github.com/natebosch/vim-lsc'
    Plug 'https://github.com/sheerun/vim-polyglot'
    Plug 'https://github.com/sbdchd/neoformat'
    Plug 'https://github.com/romainl/vim-cool'
call plug#end()

set nobackup noswapfile
set autoread
set nowrap
set tabstop=4 shiftwidth=4 expandtab
set inccommand=nosplit ignorecase
set clipboard=unnamedplus
set undofile undodir=~/.undodir

set rtp+=/usr/local/opt/fzf
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7 } }

nnoremap <leader>p :Files<space><cr>
nnoremap <leader>f :Rg<space>

let g:lsc_server_commands = { 'go': 'gopls', 'python': 'pyls', 'rust': 'rls'}
let g:lsc_enable_autocomplete = v:false
let g:lsc_auto_map = v:true

let g:netrw_banner = 0

autocmd FocusGained,BufEnter * checktime
