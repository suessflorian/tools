let mapleader = " "

call plug#begin('~/.config/nvim/plugged')

    Plug '/usr/local/opt/fzf'
    Plug 'https://github.com/junegunn/fzf.vim'

    Plug 'https://github.com/christoomey/vim-tmux-navigator'
    Plug 'https://github.com/scrooloose/nerdtree'
    Plug 'https://github.com/tpope/vim-surround'
    Plug 'https://github.com/fxn/vim-monochrome'

    Plug 'https://github.com/neovim/nvim-lsp'
    Plug 'https://github.com/fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

autocmd BufWritePre * %s/\s\+$//e

set nobackup noswapfile
set nowrap
set foldcolumn=4
set cursorline
set tabstop=2 shiftwidth=2 expandtab
set clipboard=unnamedplus
set inccommand=nosplit ignorecase

cabbrev h vert bo h

nnoremap <C-p> :Files <CR>
nnoremap <C-f> :Rg <CR>
nnoremap <leader>f :Rg <C-r><C-w><CR>
vnoremap <leader>f y:Rg <C-r>"<CR>

let reach='rg --hidden --line-number --color always --glob="!.git/*" '
command -nargs=* Rg call fzf#vim#grep(reach . shellescape(<q-args>), 0, fzf#vim#with_preview())

nnoremap <leader>gb :execute "!git blame -L " . line(".") . ",+10 %"<cr>

nnoremap <leader>bo :NERDTreeFind<CR>
let NERDTreeShowHidden=1

colorscheme monochrome
highlight VertSplit cterm=none
highlight FoldColumn ctermbg=none

call nvim_lsp#setup("pyls", {})

autocmd Filetype python setl omnifunc=v:lua.vim.lsp.omnifunc
nnoremap <silent> ;gd <cmd>lua vim.lsp.buf.definition()<CR>

autocmd FileType go nnoremap <silent> ;gd :GoDef<CR>
