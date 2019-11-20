let mapleader = " "

call plug#begin('~/.config/nvim/plugged')

    Plug '/usr/local/opt/fzf'
    Plug 'https://github.com/junegunn/fzf.vim'

    Plug 'https://github.com/scrooloose/nerdtree'
    Plug 'https://github.com/christoomey/vim-tmux-navigator'
    Plug 'https://github.com/tpope/vim-surround'
    Plug 'https://github.com/fxn/vim-monochrome'

    Plug 'https://github.com/fatih/vim-go.git'

call plug#end()

let $FZF_DEFAULT_OPTS = '--preview "head -100 {}"'
nnoremap <C-p> :Files<CR>
nnoremap <Leader>p :Fi <c-r><c-w><CR>
vnoremap <leader>p y:Fi <c-r>"<CR>

nnoremap <C-f> :Rg<space>
nnoremap <leader>f :Rg <c-r><c-w><CR>
vnoremap <leader>f y:Rg <c-r>"<CR>

command! -bang -nargs=* Fi call fzf#vim#files('.', {'options':'--query '.shellescape(<q-args>)})
command! -bang -nargs=* Rg call fzf#vim#grep('rg --line-number --hidden --color=always --smart-case --glob="!.git/*" '.shellescape(<q-args>),0, fzf#vim#with_preview({'options': '--delimiter : --nth 3..'}), <bang>0)

nnoremap <leader>gb :execute "!git blame -L " . eval(line(".")) . ",+10 %"<cr>

let NERDTreeHijackNetrw=1
let NERDTreeShowHidden=1
nnoremap <leader>bo :NERDTreeFind<CR>

set spelllang=en_nz
set foldcolumn=4
set noshowmode
set noshowcmd
set novisualbell
set nobackup
set noswapfile
set cmdheight=1
set splitright
set splitbelow
set tabstop=4
set shiftwidth=4
set scrolloff=1
set expandtab
set cursorline
cabbrev h vert h

set clipboard+=unnamedplus

autocmd BufWritePre * %s/\s\+$//e

colorscheme monochrome
highlight VertSplit cterm=none
highlight FoldColumn ctermbg=none

" Python
call lsp#add_filetype_config({
      \ 'filetype': 'python',
      \ 'name': 'pyls',
      \ 'cmd': 'pyls'
      \ })

autocmd Filetype python setl omnifunc=lsp#omnifunc
nnoremap <silent>gd :call lsp#text_document_definition()<CR>
nnoremap <silent>dh :call lsp#text_document_hover()<CR>

let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1

let g:go_fmt_command = 'goimports'
let g:go_def_mode = 'gopls'
let g:go_info_mode = 'gopls'

autocmd FileType go nnoremap <buffer> <silent>gd :GoDef<CR>
autocmd FileType go nnoremap <buffer> <leader>gd :GoDocBrowser<CR>
