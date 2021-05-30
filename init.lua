------------------------------------ PLUGINS ------------------------------------
vim.cmd 'packadd paq-nvim'
local paq = require('paq-nvim').paq

paq {'savq/paq-nvim', opt=true} -- let paq manage itself
paq {'tpope/vim-surround'}
paq {'nvim-treesitter/nvim-treesitter'}
paq {'tpope/vim-vinegar'}
paq {'neovim/nvim-lspconfig'}
paq {'ruanyl/vim-gh-line'}
paq {'junegunn/fzf', run = vim.fn['fzf#install']}
paq {'junegunn/fzf.vim'}
paq {'ojroques/nvim-lspfuzzy'}
paq {'romainl/vim-cool'}
paq {'sainnhe/sonokai'}

------------------------------------- THEME -------------------------------------
vim.cmd 'colorscheme sonokai'
vim.cmd 'let g:sonokai_disable_italic_comment = 1'
vim.cmd 'let g:sonokai_transparent_background = 1'

------------------------------------ OPTIONS ------------------------------------
vim.g.mapleader=" "

vim.opt.expandtab=true -- spaces instead of tabs
vim.opt.shiftwidth=2 -- size of a tab
vim.opt.tabstop=2 -- number of spaces tab counts for
vim.opt.shiftround=true -- round indent
vim.opt.hidden=true -- allows buffer hiding rather than abandoning

vim.opt.backup=false -- disable backup files
vim.opt.swapfile=false -- no swap files
vim.opt.autoread=true -- detect file changes outside of vim

vim.opt.cursorline=true -- show cursor line
vim.opt.inccommand="nosplit" -- show effect of command incrementally
vim.opt.mouse="a" -- let mouse do stuff
vim.opt.wrap=false -- disable text wrapping
vim.opt.undofile=true -- persistant file undo's

vim.opt.foldmethod="expr" -- treesitters determines folding
vim.opt.foldexpr='nvim_treesitter#foldexpr()'
vim.opt.foldlevel=99 -- open files unfolded

------------------------------------ MAPPINGS -----------------------------------
vim.api.nvim_set_keymap('n', '<leader>p', ':Files<space><cr>', {noremap = true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>b', ':Buffers<space><cr>', {noremap = true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>f', ':Rg<space>', {noremap = true})

---------------------------------- TREE SITTER ----------------------------------
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

------------------------------------ LS SETUP -----------------------------------
local nvim_lsp = require('lspconfig')

-- use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- <c-x><c-u>
  buf_set_option('completefunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }

  -- see `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', '<C-n>,','<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<C-p>;','<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K',     '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gt',    '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gi',    '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gf',    '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  buf_set_keymap('n', 'ga',    '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gR',    '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr',    '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'go',    '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
end

-- map buffer local keybindings when the language server attaches
local servers = { "gopls", "tsserver", "pyls", "graphql" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach, indent = { enable = true } }
end

require('lspfuzzy').setup {}  -- make the lsc use fzf instead of the quickfix list

-------------------------------------- MISC -------------------------------------
vim.cmd 'autocmd TextYankPost * lua vim.highlight.on_yank {on_visual = false}' -- highlight yanks
vim.cmd 'autocmd FocusGained,BufEnter * checktime' -- force file change check
