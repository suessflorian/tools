let mapleader = " "

call plug#begin('~/.config/nvim/plugged')

    Plug '/usr/local/opt/fzf'
    Plug 'https://github.com/junegunn/fzf.vim'

    Plug 'https://github.com/christoomey/vim-tmux-navigator'
    Plug 'https://github.com/scrooloose/nerdtree'
    Plug 'https://github.com/tpope/vim-surround'
    Plug 'https://github.com/tpope/vim-fugitive'
    Plug 'https://github.com/morhetz/gruvbox'

    Plug 'https://github.com/neovim/nvim-lsp'

call plug#end()

autocmd BufWritePre * %s/\s\+$//e

set nobackup noswapfile
set foldcolumn=4
set cursorline
set tabstop=2 shiftwidth=2 expandtab
set inccommand=nosplit ignorecase
set clipboard+=unnamedplus

cabbrev h vert bo h

nnoremap <c-p> :Files <cr>
nnoremap <c-f> :Rg <cr>
vnoremap <leader>f y:Rg <c-r>"<cr>

let reach='rg --hidden --line-number --color always --smart-case --glob="!.git/*" '
command -nargs=* Rg call fzf#vim#grep(reach . shellescape(<q-args>), 0, fzf#vim#with_preview())

nnoremap <leader>bo :NERDTreeFind<cr>
let NERDTreeShowHidden=1

call nvim_lsp#setup("pyls", {})
call nvim_lsp#setup("gopls", {})

autocmd Filetype python,go setl omnifunc=v:lua.vim.lsp.omnifunc
nnoremap <silent> <c-[> <cmd>lua vim.lsp.buf.definition()<cr>

colorscheme gruvbox
highlight VertSplit cterm=none
highlight FoldColumn ctermbg=none
highlight CursorLine ctermbg=black ctermfg=none
highlight Visual ctermbg=black ctermfg=yellow
