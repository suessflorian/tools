call plug#begin('~/.config/nvim/plugged')
  Plug 'tpope/vim-surround'
  Plug 'jiangmiao/auto-pairs'
  Plug 'tpope/vim-vinegar'
  Plug 'mattn/emmet-vim'
  Plug 'junegunn/fzf.vim'
  Plug 'ruanyl/vim-gh-line'
  Plug 'natebosch/vim-lsc'
  Plug 'sheerun/vim-polyglot'
  Plug 'romainl/vim-cool'
call plug#end()

set nobackup noswapfile
set cursorline
set autoread
set nowrap
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab
set inccommand=nosplit ignorecase
set clipboard=unnamedplus
set undofile undodir=~/.undodir

map <space> <leader>
nnoremap <leader>p :Files<space><cr>
nnoremap <leader>b :Buffers<space><cr>
nnoremap <leader>f :Rg<space>

set rtp+=/usr/local/opt/fzf
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }

let g:lsc_auto_map = v:true
let g:lsc_reference_highlights = v:false

let g:lsc_server_commands = { 
  \ 'go': 'gopls',
  \ 'typescriptreact': 'typescript-language-server --stdio',
  \ 'typescript': 'typescript-language-server --stdio',
\}

autocmd FocusGained,BufEnter * checktime
