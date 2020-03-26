let mapleader = " "

call plug#begin('~/.config/nvim/plugged')

    Plug 'https://github.com/junegunn/fzf.vim'
    Plug 'https://github.com/ruanyl/vim-gh-line'

    Plug 'https://github.com/natebosch/vim-lsc'

    Plug 'https://github.com/sheerun/vim-polyglot'
    Plug 'https://github.com/google/vim-jsonnet'
    Plug 'https://github.com/sbdchd/neoformat'

call plug#end()

set nobackup noswapfile
set nowrap
set termguicolors
set tabstop=4 shiftwidth=4 expandtab
set inccommand=nosplit ignorecase
set clipboard=unnamedplus

set rtp+=/usr/local/opt/fzf
let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_layout = { 'window': { 'width': 0.85, 'height': 0.85 } }

nnoremap <leader>p :Files<space><cr>
nnoremap <leader>f :Rg<space>

let g:lsc_server_commands = { 'go': 'gopls', 'python': 'pyls', 'javascript': 'typescript-language-server --stdio' }
let g:lsc_enable_autocomplete = v:false
let g:lsc_auto_map = v:true

let g:netrw_banner = 0

autocmd BufWritePre *.go,*.py,*.js,*.ts,*.json Neoformat
autocmd BufWritePre * %s/\s\+$//e
autocmd FocusGained * checktime
