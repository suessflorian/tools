let mapleader = " "

call plug#begin('~/.config/nvim/plugged')

    Plug '/usr/local/opt/fzf'
    Plug 'https://github.com/junegunn/fzf.vim'

    Plug 'https://github.com/christoomey/vim-tmux-navigator'
    Plug 'https://github.com/scrooloose/nerdtree'
    Plug 'https://github.com/morhetz/gruvbox'

    Plug 'https://github.com/natebosch/vim-lsc'
    Plug 'https://github.com/sbdchd/neoformat'

call plug#end()

set nobackup noswapfile foldcolumn=4
set termguicolors
set nowrap cursorline
set tabstop=2 shiftwidth=2 expandtab
set inccommand=nosplit ignorecase
set clipboard=unnamedplus

nnoremap <leader>p :Files <cr>
nnoremap <leader>f :Rg <cr>
vnoremap <leader>f y:Rg <c-r>"<cr>

let reach='rg --hidden --line-number --color always --smart-case --glob="!.git/*" '
command -nargs=* Rg call fzf#vim#grep(reach . shellescape(<q-args>), 0, fzf#vim#with_preview())

nnoremap <leader>bo :NERDTreeFind<cr>
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1

colorscheme gruvbox
highlight VertSplit gui=none
highlight FoldColumn guibg=none
highlight CursorLine guibg=#232323 guifg=none
highlight Visual guifg=#fabd2f guibg=#000000

let g:lsc_server_commands = { 'go': 'gopls', 'python': 'pyls' }
let g:lsc_enable_autocomplete = v:false
let g:lsc_auto_map = v:true

autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * Neoformat
autocmd FocusGained * checktime

