call plug#begin('~/.config/nvim/plugged')
  Plug 'sainnhe/sonokai'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-vinegar'
  Plug 'junegunn/fzf.vim'
  Plug 'ruanyl/vim-gh-line'
  Plug 'natebosch/vim-lsc'
  Plug 'sheerun/vim-polyglot'
  Plug 'romainl/vim-cool'
  Plug 'w0rp/ale'
call plug#end()

let g:sonokai_disable_italic_comment = 1
let g:sonokai_transparent_background = 1
colorscheme sonokai

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
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.95 } }

let g:lsc_auto_map = v:true
let g:lsc_reference_highlights = v:false

let g:lsc_server_commands = { 
  \ 'go': 'gopls',
  \ 'typescriptreact': 'typescript-language-server --stdio',
  \ 'typescript': 'typescript-language-server --stdio',
  \ 'javascript': 'typescript-language-server --stdio',
\}

let g:ale_set_signs = 0
let g:ale_completion_enabled = 0
let g:ale_virtualtext_cursor = 1

autocmd FocusGained,BufEnter * checktime
