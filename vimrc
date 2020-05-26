let mapleader = " "

call plug#begin('~/.config/nvim/plugged')
  Plug 'https://github.com/tpope/vim-surround'
  Plug 'https://github.com/jiangmiao/auto-pairs'
  Plug 'https://github.com/tpope/vim-vinegar'
  Plug 'https://github.com/mattn/emmet-vim'
  Plug 'https://github.com/junegunn/fzf.vim'
  Plug 'https://github.com/ruanyl/vim-gh-line'
  Plug 'https://github.com/natebosch/vim-lsc'
  Plug 'https://github.com/sheerun/vim-polyglot'
  Plug 'https://github.com/romainl/vim-cool'
call plug#end()

highlight Comment cterm=italic
imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

set nobackup noswapfile
set autoread
set nowrap
set tabstop=2 shiftwidth=2 expandtab
set inccommand=nosplit ignorecase
set clipboard=unnamedplus
set undofile undodir=~/.undodir

set rtp+=/usr/local/opt/fzf
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }

nnoremap <leader>p :Files<space><cr>
nnoremap <leader>b :Buffers<space><cr>

let g:lsc_auto_map = v:true
let g:lsc_enable_diagnostics = v:false

let g:lsc_server_commands = { 
  \ 'go': 'gopls',
  \ 'python': 'pyls',
  \ 'typescriptreact': 'typescript-language-server --stdio',
  \ 'css': 'css-languageserver --stdio'
\}

autocmd FocusGained,BufEnter * checktime
