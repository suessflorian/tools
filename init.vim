let mapleader = " "

call plug#begin('~/.config/nvim/plugged')

    Plug '/usr/local/opt/fzf'
    Plug 'https://github.com/junegunn/fzf.vim'

    Plug 'https://github.com/christoomey/vim-tmux-navigator'
    Plug 'https://github.com/scrooloose/nerdtree'
    Plug 'https://github.com/morhetz/gruvbox'

    Plug 'https://github.com/natebosch/vim-lsc'
    Plug 'https://github.com/sheerun/vim-polyglot'
    Plug 'https://github.com/sbdchd/neoformat'

call plug#end()

set nobackup noswapfile
set nowrap
set termguicolors
set tabstop=4 shiftwidth=4 expandtab
set inccommand=nosplit ignorecase
set clipboard=unnamedplus

nnoremap <leader>p :Files <cr>
nnoremap <leader>f :Rg <cr>
vnoremap <leader>f y:Rg <c-r>"<cr>

let $FZF_DEFAULT_OPTS="--reverse "
let reach='rg --hidden --line-number --color always --glob="!.git/*" '
command -nargs=* Rg call fzf#vim#grep(reach . shellescape(<q-args>), 0, fzf#vim#with_preview())

nnoremap <leader>bo :NERDTreeFind<cr>
let NERDTreeShowHidden=1

colorscheme gruvbox
highlight Visual guifg=#CC880B guibg=#000000

let g:lsc_server_commands = { 'go': 'gopls', 'python': 'pyls', 'javascript': 'typescript-language-server --stdio' }
let g:lsc_enable_autocomplete = v:false
let g:lsc_auto_map = v:true

autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre *.go,*.py,*.js,*.ts Neoformat
autocmd FocusGained * checktime
