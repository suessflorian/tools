let mapleader = " "

call plug#begin('~/.config/nvim/plugged')
    Plug 'https://github.com/junegunn/fzf.vim'
    Plug 'https://github.com/ruanyl/vim-gh-line'
    Plug 'https://github.com/natebosch/vim-lsc'
    Plug 'https://github.com/sheerun/vim-polyglot'
    Plug 'https://github.com/romainl/vim-cool'
    Plug 'https://github.com/morhetz/gruvbox'
call plug#end()

colorscheme gruvbox
hi Visual ctermfg=Yellow ctermbg=Black gui=none
hi Comment cterm=italic

set nobackup noswapfile
set autoread
set nowrap
set tabstop=2 shiftwidth=2 expandtab
set inccommand=nosplit ignorecase
set clipboard=unnamedplus
set undofile undodir=~/.undodir

set rtp+=/usr/local/opt/fzf
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7 } }

nnoremap <leader>p :Files<space><cr>

let g:lsc_auto_map = v:true
let g:lsc_server_commands = { 
            \ 'go': 'gopls', 
            \ 'python': 'pyls',
            \ 'typescriptreact': 'typescript-language-server --stdio',
\}

let g:netrw_banner = 0

autocmd FocusGained,BufEnter * checktime
