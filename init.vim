let mapleader = " "

call plug#begin('~/.config/nvim/plugged')

  " syntax colors
  Plug 'https://github.com/sheerun/vim-polyglot.git'

  " language support
  Plug 'https://github.com/fatih/vim-go.git' " Golang
  Plug 'https://github.com/davidhalter/jedi-vim.git' " Python

  " cosmetic
  Plug 'https://github.com/NLKNguyen/papercolor-theme.git'
  Plug 'https://github.com/suessflorian/vim-cleaner-airline-theme.git'

  " functionality support
  Plug 'https://github.com/vim-airline/vim-airline.git'
  Plug '/usr/local/opt/fzf'
  Plug 'https://github.com/junegunn/fzf.vim.git'
  Plug 'https://github.com/scrooloose/nerdtree.git'
  Plug 'https://github.com/jiangmiao/auto-pairs.git'
  Plug 'https://github.com/tpope/vim-surround.git'

  " tmux navigation integration support
  Plug 'https://github.com/christoomey/vim-tmux-navigator.git'

call plug#end()

nnoremap <Leader>n :set relativenumber!<cr>

" spell checking
nnoremap <leader>s :setlocal spell! spelllang=en_nz<CR>

let g:PaperColor_Theme_Options = {'theme': {'default': {'transparent_background': 1}}}
let g:airline_theme = 'cleaner'
colorscheme PaperColor

" reaching preferences
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l -g ""'
nnoremap <C-p> :Files<CR>
nnoremap <Leader>p :Fi <c-r><c-w><CR>
vnoremap <leader>p y:Fi <c-r>"<CR>

nnoremap <C-f> :Rg<space>
nnoremap <leader>f :Rg <c-r><c-w><CR>
vnoremap <leader>f y:Rg <c-r>"<CR>

command! -bang -nargs=* Fi call fzf#vim#files('.', {'options':'--query '.shellescape(<q-args>)})
command! -bang -nargs=* Rg call fzf#vim#grep('rg --line-number --hidden --no-heading --color=always --smart-case '.shellescape(<q-args>),1, fzf#vim#with_preview({'options': '--delimiter : --nth 3..'}), <bang>0)

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine',  'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', ],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" navigate visual lines rather than physical on wrapped buffers
nnoremap j gj
nnoremap k gk

" faster documentation
cabbrev h vert h

noremap <leader>gb :execute "!git blame -L " . eval(line(".")) . ",+10 %"<cr>

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
let g:go_def_mapping_enabled = 1

" vim go shortcuts
nnoremap <leader>gd :GoDocBrowser<CR>

" python preferences
let g:jedi#auto_initialization = 0
autocmd FileType python nnoremap <leader>rn :call jedi#rename()<cr>
autocmd FileType python nnoremap <silent>gd :call jedi#goto()<cr>

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

" buffer navigation
nnoremap <S-j> :bprevious<CR>
nnoremap <S-k> :bnext<CR>
nnoremap <leader>x :bd<CR>

" NERDTree preferences
let NERDTreeHijackNetrw = 1
let NERDTreeShowHidden=1
nnoremap <leader>bo :NERDTreeFind<CR>

" sensibles
set foldcolumn=0
set ignorecase
set noerrorbells
set noshowmode
set noshowcmd
set novisualbell
set nobackup
set noswapfile
set cmdheight=1
set splitright
set splitbelow
set hidden
set clipboard+=unnamedplus
set expandtab
set shiftwidth=2
set tabstop=2
set smartindent
set background=light

" split sizing bindings
nnoremap _ :vertical resize -5<CR>
nnoremap + :vertical resize +5<CR>

" highlight all instances of word under cursor
nnoremap <leader>h :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
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

" remove all trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

highlight VertSplit cterm=none
highlight Visual ctermfg=white ctermbg=3
highlight Search ctermfg=white ctermbg=3
