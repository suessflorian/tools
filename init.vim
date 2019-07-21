let mapleader = " "

call plug#begin('~/.config/nvim/plugged')

  " syntax support
  Plug 'https://github.com/pangloss/vim-javascript.git'
  Plug 'https://github.com/mxw/vim-jsx.git'
  Plug 'https://github.com/elzr/vim-json.git'
  Plug 'https://github.com/moll/vim-node.git'

  " layout/appearance support
  Plug 'https://github.com/NLKNguyen/papercolor-theme.git'
  Plug 'https://github.com/vim-airline/vim-airline.git'
  Plug 'https://github.com/suessflorian/vim-cleaner-airline-theme.git'

  " language support
  Plug 'https://github.com/fatih/vim-go.git'
  Plug 'https://github.com/neovimhaskell/haskell-vim.git'

  " functionality support
  Plug 'https://github.com/scrooloose/nerdtree.git'
  Plug 'https://github.com/junegunn/fzf.vim.git'
  Plug '/usr/local/opt/fzf'
  Plug 'https://github.com/jiangmiao/auto-pairs.git'
  Plug 'https://github.com/tpope/vim-surround.git'
  Plug 'https://github.com/prettier/vim-prettier.git', { 'do': 'yarn install' }
  Plug 'https://github.com/iamcco/markdown-preview.nvim.git', { 'do': { -> mkdp#util#install() } }

  " tmux integration
  Plug 'https://github.com/christoomey/vim-tmux-navigator.git'

call plug#end()

" paper colouring
set background=light
let g:PaperColor_Theme_Options = {'theme': {'default': {'transparent_background': 1}}}
colorscheme PaperColor

" airline theme, getting rid of all the colours
let g:airline_theme = 'cleaner'

" reaching preferences
nnoremap <C-p> :Files<CR>
nnoremap <Leader>p :Fi <c-r><c-w><CR>
vnoremap <leader>p y:Fi <c-r>"<CR>

nnoremap <C-f> :Rg<space>
nnoremap <leader>f :Rg <c-r><c-w><CR>
vnoremap <leader>f y:Rg <c-r>"<CR>

command! -bang -nargs=* Fi call fzf#vim#files('.', {'options':'--query '.shellescape(<q-args>)})
command! -bang -nargs=* Rg call fzf#vim#grep('rg --line-number --hidden --no-heading --color=always --smart-case '.shellescape(<q-args>),1, fzf#vim#with_preview({'options': '--delimiter : --nth 3..'}), <bang>0)

" navigate visual lines rather than physical on wrapped buffers
nnoremap j gj
nnoremap k gk

" bring up vim documentation quicker
cabbrev h vert h

noremap <leader>gb :!git blame -- %<cr>

" haskell preferences
let g:haskell_enable_quantification = 1
let g:haskell_enable_recursivedo = 1
let g:haskell_enable_arrowsyntax = 1
let g:haskell_enable_pattern_synonyms = 1
let g:haskell_enable_typeroles = 1
let g:haskell_enable_static_pointers = 1
let g:haskell_backpack = 1

" go preferences
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_doc_keywordprg_enabled = 0
let g:go_fmt_command = "goimports"
let g:go_def_mode = 'gopls'
let g:go_info_mode = 'gopls'

" vim go shortcuts
nnoremap <leader>gd :GoDocBrowser<CR>

" ripping out extraneous information
let g:airline_symbols = {}
let g:airline_section_x=''
let g:airline_section_y=''
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_skip_empty_sections = 1
let g:airline_section_z = "%3p %%"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#tab_nr_type = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tab_count = 0
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''

" buffer navigation preferences
nnoremap <S-j> :bprevious<CR>
nnoremap <S-k> :bnext<CR>
nnoremap <leader>x :bd<CR>

" NERDTree preferences
let g:NERDTreeHijackNetrw = 1
let NERDTreeShowHidden=1
let NERDTreeMapJumpLastChild=''
let NERDTreeMapJumpFirstChild=''
nnoremap <leader>bo :NERDTreeFind<CR>

" appearances
set number
set foldcolumn=0
set nowrap
set hlsearch
set ignorecase
set scrolloff=0
set wildmenu
set noerrorbells
set noshowmode
set noshowcmd
set novisualbell
set nobackup
set cmdheight=1
set noswapfile
set encoding=utf8
set history=1000
set clipboard+=unnamedplus
set splitright
set splitbelow
set mouse=a

" tabbing preferences
set expandtab
set smarttab
set shiftwidth=2
set tabstop=2
set autoindent
set smartindent

" italic comments
set t_ZH=\e[3m
set t_ZR=\e[23m
highlight Comment cterm=italic

highlight VertSplit cterm=none
highlight LineNr ctermfg=black ctermbg=none
highlight Visual cterm=italic ctermfg=white ctermbg=lightyellow
highlight Search cterm=italic,underline ctermfg=white ctermbg=lightyellow

" split sizing bindings
nnoremap _ :vertical resize -5<CR>
nnoremap + :vertical resize +5<CR>

" highlight all instances of word under cursor, when idle.
nnoremap <leader>hi :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight Auxiliary: OFF'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=1
    echo 'Highlight Auxiliary: ON'
    return 1
  endif
endfunction

" <A-j/k> movements
nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==
inoremap ∆ <Esc>:m .+1<CR>==gi
inoremap ˚<Esc>:m .-2<CR>==gi
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv

" remove all trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e
