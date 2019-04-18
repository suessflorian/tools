
"    ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"    ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"    ██║   ██║██║██╔████╔██║██████╔╝██║
"    ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║
"  ██╗╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"  ╚═╝ ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝

let mapleader = " "

call plug#begin('~/.config/nvim/plugged')

  Plug 'https://github.com/pangloss/vim-javascript.git'
  Plug 'https://github.com/mxw/vim-jsx.git'
  Plug 'https://github.com/elzr/vim-json.git'
  Plug 'https://github.com/moll/vim-node.git'
  Plug 'https://github.com/christoomey/vim-tmux-navigator.git'
  Plug 'https://github.com/zivyangll/git-blame.vim.git'
  Plug 'https://github.com/fatih/vim-go.git'
  Plug '/usr/local/opt/fzf'
  Plug 'https://github.com/junegunn/fzf.vim.git'
  Plug 'https://github.com/vim-airline/vim-airline.git'
  Plug 'https://github.com/vim-airline/vim-airline-themes.git'
  Plug 'https://github.com/prettier/vim-prettier.git', { 'do': 'yarn install' }
  Plug 'https://github.com/jiangmiao/auto-pairs.git'
  Plug 'https://github.com/tpope/vim-surround.git'
  Plug 'https://github.com/w0rp/ale.git'
  Plug 'https://github.com/scrooloose/nerdtree.git'
  Plug 'https://github.com/iamcco/markdown-preview.nvim.git', { 'do': { -> mkdp#util#install() } }
  Plug 'https://github.com/neovimhaskell/haskell-vim.git'

call plug#end()

" reaching preferences
nnoremap <C-p> :Files<CR>
nnoremap <Leader>p :Fi <c-r><c-w><CR>
vnoremap <leader>p y:Fi <c-r>"<CR>

nnoremap <C-f> :Rg<space>
nnoremap <leader>f :Rg <c-r><c-w><CR>
vnoremap <leader>f y:Rg <c-r>"<CR>

nnoremap / :BLines<CR>
nnoremap <leader>: :Commands<CR>

command! -bang -nargs=* Fi call fzf#vim#files('.', {'options':'--query '.shellescape(<q-args>)})
command! -bang -nargs=* Rg call fzf#vim#grep('rg --line-number --hidden --no-heading --color=always --smart-case '.shellescape(<q-args>), 1, {'options': '--delimiter : --nth 3..'}, <bang>0)

nnoremap gb :<C-u>call gitblame#echo()<CR>

" basic preferences
set noerrorbells
set novisualbell
set nobackup
set cmdheight=1
nnoremap q: :q

let g:ale_completion_enabled = 1

" navigate visual lines rather than physical on wrapped buffers
nnoremap j gj
nnoremap k gk

set encoding=utf8
set history=1000
set clipboard+=unnamedplus
set splitright
set splitbelow
cabbrev h vert h
set mouse=a

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

" ALE preferences
let g:airline#extensions#ale#enabled = 1

let g:ale_enabled=0
nnoremap <leader>al :ALEEnable<CR>
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
highlight SignColumn ctermfg=black ctermbg=NONE
highlight Error ctermfg=1 ctermbg=NONE
highlight Todo ctermfg=3 ctermbg=NONE

let g:ale_set_loclist = 0	
let g:ale_set_highlights = 0	
let g:ale_disable_lsp = 1

let g:ale_linters = 	
     \{	
     \ 'javascript.jsx': ['eslint', 'flow', 'flow-language-server'],	
     \ 'javascript': ['eslint', 'flow', 'flow-language-server'],	
     \ 'go': [],
     \ 'php': ['php', 'langserver'],	
     \}	

inoremap <c-space> <c-x><c-o>
highlight Pmenu ctermbg=238 gui=bold

let g:ale_php_langserver_executable = expand('~/.config/composer/vendor/bin/php-language-server.php')	

autocmd FileType php nnoremap <buffer> gd :ALEGoToDefinition<CR>
autocmd FileType javascript nnoremap <buffer> gd :ALEGoToDefinition<CR>
autocmd FileType javascript.jsx nnoremap <buffer> gd :ALEGoToDefinition<CR>

" vim-airline base preferences
let g:airline_section_x=''
let g:airline_section_y=''
let g:airline_skip_empty_sections = 1
let g:airline#extensions#whitespace#enabled = 0

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_section_z = "%3p %%"
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''

" vim airline top preferences 
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#tab_nr_type = 0
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tab_count = 0

" buffer navigation preferences
nnoremap <C-x> :bufdo bd<CR>
nnoremap <S-j> :bprevious<CR>
nnoremap <S-k> :bnext<CR>
nnoremap <leader>x :bd<CR>

" NERDTree preferences
let g:NERDTreeSortOrder=['\/$', '*', '\.swp$', '\.bak$', '\~$', '[[timestamp]]']
let g:NERDTreeHijackNetrw = 1
let NERDTreeShowHidden=1
let NERDTreeMapJumpLastChild=''
let NERDTreeMapJumpFirstChild=''
nnoremap <C-b> :NERDTree<CR>
nnoremap <leader>bo :NERDTreeFind<CR>

" prettier preferences
let g:prettier#autoformat = 0
let g:prettier#exec_cmd_async = 1
let g:prettier#quickfix_enabled = 0

" appearances
set number
set foldcolumn=0
set nowrap
set hlsearch
set ignorecase
set scrolloff=0
set wildmenu
set t_ZH=\e[3m
set t_ZR=\e[23m
highlight Comment cterm=italic
highlight VertSplit cterm=none
highlight LineNr ctermfg=16 ctermbg=none 
highlight Visual cterm=italic ctermfg=black ctermbg=3
highlight Search cterm=italic,underline ctermfg=3 ctermbg=none

let g:airline_theme='badcat'

" syntax preferences 
let g:javascript_plugin_flow=1

" tabbing preferences
set expandtab
set smarttab
set shiftwidth=2
set tabstop=2
set autoindent
set smartindent

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
