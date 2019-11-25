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

nnoremap <C-p> :Files<CR>

nnoremap <C-f> :Rg<space>
nnoremap <leader>f :Rg <c-r><c-w><CR>
vnoremap <leader>f y:Rg <c-r>"<CR>

let rg_options='rg --line-number --hidden --color=always --smart-case --glob="!.git/*" '
command! -bang -nargs=* Rg call fzf#vim#grep(rg_options.shellescape(<q-args>), 0, fzf#vim#with_preview({'options': '--delimiter : --nth 3..'}), <bang>0)

nnoremap <leader>gb :execute "!git blame -L " . eval(line(".")) . ",+10 %"<cr>

let NERDTreeHijackNetrw=1
let NERDTreeShowHidden=1
nnoremap <leader>bo :NERDTreeFind<CR>

set spelllang=en_nz
set foldcolumn=4
set novisualbell
set nobackup
set noswapfile
set cmdheight=1
set splitright
set splitbelow
set tabstop=2
set shiftwidth=2
set expandtab
set nowrap
set cursorline
cabbrev h vert h

set clipboard+=unnamedplus

autocmd BufWritePre * %s/\s\+$//e

colorscheme monochrome
highlight VertSplit cterm=none
highlight FoldColumn ctermbg=none

call nvim_lsp#setup("gopls", {})
call nvim_lsp#setup("pyls", {})

autocmd Filetype python,go setl omnifunc=v:lua.vim.lsp.omnifunc
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> ;h  <cmd>lua vim.lsp.buf.hover()<CR>
