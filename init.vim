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

autocmd BufWritePre * :Neoformat

set nobackup noswapfile
set nowrap cursorline foldcolumn=4
set tabstop=2 shiftwidth=2 expandtab
set inccommand=nosplit ignorecase
set clipboard+=unnamedplus

cabbrev h vert bo h

nnoremap <leader>p :Files <cr>
nnoremap <leader>f :Rg <cr>
vnoremap <leader>f y:Rg <c-r>"<cr>

let reach='rg --hidden --line-number --color always --smart-case --glob="!.git/*" '
command -nargs=* Rg call fzf#vim#grep(reach . shellescape(<q-args>), 0, fzf#vim#with_preview())

nnoremap <leader>bo :NERDTreeFind<cr>
let NERDTreeShowHidden=1

colorscheme gruvbox
highlight FoldColumn ctermbg=none
highlight VertSplit cterm=none
highlight CursorLine ctermbg=black ctermfg=none
highlight Visual ctermbg=black ctermfg=yellow

let g:lsc_server_commands = { 'go': 'gopls', 'python': 'pyls' }
let g:lsc_enable_autocomplete = v:false
let g:lsc_auto_map = v:true
