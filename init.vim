let mapleader = " "

call plug#begin('~/.config/nvim/plugged')

    Plug 'https://github.com/junegunn/fzf.vim'
    Plug 'https://github.com/ruanyl/vim-gh-line'

    Plug 'https://github.com/natebosch/vim-lsc'

    Plug 'https://github.com/sheerun/vim-polyglot'
    Plug 'https://github.com/google/vim-jsonnet'
    Plug 'https://github.com/sbdchd/neoformat'

    Plug 'https://github.com/scrooloose/nerdtree'
    Plug 'https://github.com/morhetz/gruvbox'

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
nnoremap <leader>b :Buffers<space><cr>
nnoremap <leader>f :Rg<space>

let reach='rg --hidden --line-number --color always --glob="!.git/*" '
command -nargs=* Rg call fzf#vim#grep(reach . shellescape(<q-args>), 0, fzf#vim#with_preview())

nnoremap <leader>o :NERDTreeFind <cr>
let NERDTreeShowHidden=1

colorscheme gruvbox
highlight Visual guifg=#CC880B guibg=#000000

let g:lsc_server_commands = { 'go': 'gopls', 'python': 'pyls', 'javascript': 'typescript-language-server --stdio' }
let g:lsc_enable_autocomplete = v:false
let g:lsc_auto_map = v:true

autocmd BufWritePre *.go,*.py,*.js,*.ts,*.json Neoformat
autocmd BufWritePre * %s/\s\+$//e
autocmd FocusGained * checktime
