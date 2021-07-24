local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

require'packer'.startup(function()
  use {'tpope/vim-surround'}
  use {'nvim-treesitter/nvim-treesitter'}
  use {'neovim/nvim-lspconfig'}
  use {'kabouzeid/nvim-lspinstall'}
  use {'glepnir/lspsaga.nvim'}
  use {'tpope/vim-vinegar'}
  use {'ruanyl/vim-gh-line'}
  use {'romainl/vim-cool'}
  use {'projekt0n/github-nvim-theme'}
  use {'p00f/nvim-ts-rainbow'}
  use {'hrsh7th/nvim-compe'}
  use {'lewis6991/gitsigns.nvim'}
  use {'cohama/lexima.vim'}
  use {'nvim-lua/plenary.nvim'}
  use {'nvim-lua/popup.nvim'}
  use {'nvim-telescope/telescope.nvim'}
  use {'hoob3rt/lualine.nvim'}
end)

------------------------------------- THEME -------------------------------------
require('github-theme').setup({transparent = true})
require('lualine').setup({options = {theme = 'github'}})

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

vim.opt.cursorline=true
vim.opt.clipboard='unnamedplus' -- sync clipboard and default register
vim.opt.inccommand='nosplit' -- show effect of command incrementally
vim.opt.completeopt='menuone,noinsert,noselect' -- tweaking complete menu behaviour
vim.opt.mouse='a' -- let mouse do stuff
vim.opt.wrap=false -- disable text wrapping
vim.opt.undofile=true -- persistant file undo's

vim.opt.foldmethod='expr' -- treesitters determines folding
vim.opt.foldexpr='nvim_treesitter#foldexpr()'
vim.opt.foldlevel=99 -- open files unfolded

------------------------------------ MAPPINGS -----------------------------------

vim.api.nvim_set_keymap('n', '<leader>p', ':Telescope find_files<cr>', {noremap = true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>b', ':Telescope buffers<cr>', {noremap = true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>F', ':Telescope live_grep<cr>', {noremap = true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>f', ':Telescope grep_string<cr>', {noremap = true, silent=true})

---------------------------------- TREE SITTER ----------------------------------
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}, rainbow={enable=true}}

------------------------------------ LS SETUP -----------------------------------
local nvim_lsp = require('lspconfig')

-- on_attach lifecycle function maps keys to buffers as needed
local on_attach = function(client, bufnr)
--  saga.init_lsp_saga()
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('completefunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', '<C-n>,','<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', opts)
  buf_set_keymap('n', '<C-p>;','<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', opts)
  buf_set_keymap('n', '<C-]>', ':Telescope lsp_definitions<cr>', opts)
  buf_set_keymap('n', 'K',     ':Lspsaga hover_doc<cr>', opts)
  buf_set_keymap('n', 'gs',    ':Lspsaga signature_help<cr>', opts)
  buf_set_keymap('n', 'gt',    '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  buf_set_keymap('n', 'gi',    ':Telescope lsp_implementations<cr>', opts)
  buf_set_keymap('n', 'gf',    '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
  buf_set_keymap('n', 'ga',    ':Telescope lsp_code_actions<cr>', opts)
  buf_set_keymap('n', 'gR',    ':Lspsaga rename<cr>', opts)
  buf_set_keymap('n', 'gr',    ':Telescope lsp_references<cr>', opts)
  buf_set_keymap('n', 'go',    ':Telescope lsp_document_symbols<cr>', opts)
end

require'lspinstall'.setup() -- important

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup{ on_attach = on_attach, indent = { enable = true } }
end

require('compe').setup({
  enabled = true,
  source = {
    path = true,
    nvim_lsp = true,
    nvim_lua = true,
  },
})

-------------------------------------- MISC -------------------------------------
vim.cmd 'autocmd TextYankPost * silent! lua vim.highlight.on_yank()' -- highlight jumps
vim.cmd 'autocmd FocusGained,BufEnter * checktime' -- force file change check
vim.cmd 'autocmd BufNewFile,BufRead *.graphql set filetype=graphql'

-------------------------------------- GIT --------------------------------------
require('gitsigns').setup({
  current_line_blame = true,
})
