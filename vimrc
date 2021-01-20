call plug#begin('~/.config/nvim/plugged')
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-vinegar'
  Plug 'junegunn/fzf.vim'
  Plug 'ruanyl/vim-gh-line'
  Plug 'natebosch/vim-lsc', { 'commit': 'c2cb9b73a593e6e3a662934d1ce0d2e992fe45e1'}
  Plug 'sheerun/vim-polyglot'
  Plug 'romainl/vim-cool'
  Plug 'dominikduda/vim_current_word'
  Plug 'sainnhe/sonokai'
call plug#end()

let g:sonokai_disable_italic_comment = 1
let g:sonokai_transparent_background = 1
colorscheme sonokai
highlight Search cterm=NONE ctermfg=white ctermbg=NONE
highlight IncSearch cterm=NONE ctermfg=black ctermbg=white
highlight SpellCap cterm=underline ctermfg=darkyellow ctermbg=NONE 
highlight SpellBad cterm=underline ctermfg=darkred ctermbg=NONE 

set nobackup noswapfile
set cursorline
set autoread
set mouse=a
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
  \ 'python': 'pyls',
\}

autocmd FocusGained,BufEnter * checktime
