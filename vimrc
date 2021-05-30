if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.config/nvim/plugged')
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-vinegar'
  Plug 'junegunn/fzf.vim'
  Plug 'ruanyl/vim-gh-line'
  Plug 'natebosch/vim-lsc'
  Plug 'sheerun/vim-polyglot'
  Plug 'romainl/vim-cool'
  Plug 'dominikduda/vim_current_word'
  Plug 'sainnhe/sonokai'
  Plug 'sbdchd/neoformat'
call plug#end()

let g:sonokai_disable_italic_comment = 1
let g:sonokai_transparent_background = 1
colorscheme sonokai
highlight Search cterm=NONE ctermfg=white ctermbg=NONE
highlight IncSearch cterm=NONE ctermfg=black ctermbg=white
highlight SpellCap cterm=underline ctermfg=darkyellow ctermbg=NONE
highlight SpellBad cterm=underline ctermfg=darkred ctermbg=NONE

hi ExtraWhitespace cterm=underline
match ExtraWhitespace /\s\+\%#\@<!$/

set nobackup noswapfile autoread
set cursorline
set mouse=a
set nowrap
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab
set inccommand=nosplit
set clipboard=unnamedplus
set undofile undodir=~/.undodir

augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

map <space> <leader>
nnoremap <leader>p :Files<space><cr>
nnoremap <leader>b :Buffers<space><cr>
nnoremap <leader>f :Rg<space>

set rtp+=/usr/local/opt/fzf

let g:lsc_auto_map = v:true
let g:lsc_reference_highlights = v:false

let g:lsc_server_commands = {
  \ "go": {
  \   "command": "gopls serve",
  \   "log_level": -1,
  \   "suppress_stderr": v:true
  \},
  \ "javascript": "typescript-language-server --stdio",
  \ "typescript": "typescript-language-server --stdio",
  \ 'python': 'pyls',
\}

autocmd FocusGained,BufEnter * checktime
