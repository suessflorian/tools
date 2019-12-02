let mapleader = " "

call plug#begin('~/.config/nvim/plugged')

    Plug '/usr/local/opt/fzf'
    Plug 'https://github.com/junegunn/fzf.vim'

    Plug 'https://github.com/christoomey/vim-tmux-navigator'
    Plug 'https://github.com/scrooloose/nerdtree'
    Plug 'https://github.com/tpope/vim-surround'
    Plug 'https://github.com/fxn/vim-monochrome'
    Plug 'https://github.com/neovim/nvim-lsp'

call plug#end()

set nobackup noswapfile
set nowrap
set spelllang=en_nz
set foldcolumn=4
set cursorline
set tabstop=2 shiftwidth=2 expandtab
set clipboard=unnamedplus

autocmd BufWritePre * %s/\s\+$//e

cabbrev h vert bo h

nnoremap <C-p> :Files <CR>
nnoremap <C-f> :Rg<SPACE>
nnoremap <C-b> :Buffer <CR>
nnoremap <LEADER>f :Rg <C-R><C-W><CR>
vnoremap <LEADER>f y:Rg <C-R>"<CR>

let reach='rg --line-number --hidden --color=always --smart-case --glob="!.git/*" '
command -nargs=* Rg call fzf#vim#grep(reach . shellescape(<q-args>), 0, fzf#vim#with_preview())

nnoremap <leader>gb :execute "!git blame -L " . line(".") . ",+10 %"<cr>

nnoremap <leader>bo :NERDTreeFind<CR>
let NERDTreeShowHidden=1

colorscheme monochrome
highlight VertSplit cterm=none
highlight FoldColumn ctermbg=none

call nvim_lsp#setup("gopls", {})
call nvim_lsp#setup("pyls", {})

autocmd Filetype python,go setl omnifunc=v:lua.vim.lsp.omnifunc
nnoremap <silent> ;gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> ;ho  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> ;rf <cmd>lua vim.lsp.buf.references()<CR>
