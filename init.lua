-- install packer if not present
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.api.nvim_command 'packadd packer.nvim'
end

require('packer').startup(function()
  use {'kdheepak/lazygit.nvim'}
  use {'iamcco/markdown-preview.nvim'}
  use {'wbthomason/packer.nvim'}
  use {'tpope/vim-surround'}
  use {'tpope/vim-vinegar'}
  use {'nvim-treesitter/nvim-treesitter'}
  use {'neovim/nvim-lspconfig'}
  use {'kabouzeid/nvim-lspinstall'}
  use {'glepnir/lspsaga.nvim'}
  use {'ruanyl/vim-gh-line'}
  use {'romainl/vim-cool'}
  use {'navarasu/onedark.nvim'}
  use {'p00f/nvim-ts-rainbow'}
  use {'hrsh7th/nvim-compe'}
  use {'cohama/lexima.vim'}
  use {'sbdchd/neoformat'}
  use {'hoob3rt/lualine.nvim'}
  use {'alvan/vim-closetag'}
  use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/plenary.nvim'}, {'kyazdani42/nvim-web-devicons'}}}
end)

------------------------------------- THEME -------------------------------------
vim.g.onedark_transparent_background = true
require('onedark').setup()
require('lualine').setup({options = {theme = "onedark"}})

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

vim.g.closetag_filenames = '*.html,*.js*,*.ts*' -- where lexima is active
vim.g.neoformat_try_node_exe=1 -- uses project formatter dependancy if available

------------------------------------ FINDERS ------------------------------------
vim.api.nvim_set_keymap('n', '<leader>p', ':Telescope find_files<cr>', {noremap = true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>b', ':Telescope buffers<cr>', {noremap = true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>F', ':Telescope live_grep<cr>', {noremap = true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>f', ':Telescope grep_string<cr>', {noremap = true, silent=true})

------------------------------------ MAPPINGS -----------------------------------
vim.api.nvim_set_keymap('n', 'gf', ':Neoformat <cr>', {noremap = true, silent=true})

---------------------------------- TREE SITTER ----------------------------------
local ts = require('nvim-treesitter.configs')
ts.setup({ensure_installed = 'maintained', highlight = { enable = true }, rainbow={ enable=true } })

------------------------------------ LS SETUP -----------------------------------
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', '<C-n>,',     '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', opts)
  buf_set_keymap('n', '<C-p>;',     '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', opts)
  buf_set_keymap('n', '<C-]>',      ':Telescope lsp_definitions<cr>', opts)
  buf_set_keymap('n', '<leader>k',  ':Lspsaga hover_doc<cr>', opts)
  buf_set_keymap('n', 'gs',         ':Lspsaga signature_help<cr>', opts)
  buf_set_keymap('n', 'gt',         '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  buf_set_keymap('n', 'gi',         ':Telescope lsp_implementations<cr>', opts)
  buf_set_keymap('n', 'ga',         ':Telescope lsp_code_actions<cr>', opts)
  buf_set_keymap('n', 'gR',         ':Lspsaga rename<cr>', opts)
  buf_set_keymap('n', 'gr',         ':Telescope lsp_references<cr>', opts)
  buf_set_keymap('n', 'go',         ':Telescope lsp_document_symbols<cr>', opts)
end

require'lspinstall'.setup()
local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup{ on_attach = on_attach, indent = { enable = true } }
end

require('compe').setup({
  enabled = true,
  source = {
    path = true,
    nvim_lsp = true,
  },
})

-------------------------------------- MISC -------------------------------------
vim.cmd 'autocmd TextYankPost * silent! lua vim.highlight.on_yank()' -- highlight yank section
vim.cmd 'autocmd FocusGained,BufEnter * checktime' -- force file change check
vim.cmd 'autocmd BufNewFile,BufRead *.graphql set filetype=graphql'

-------------------------------------- GIT --------------------------------------
vim.api.nvim_set_keymap('n', '<c-space>', ':LazyGit<cr>', {noremap = true, silent=true})
vim.cmd 'let $GIT_EDITOR = "nvr -cc split --remote-wait"' -- when in lazygit utulise neovim remote to re-attach to current instance
vim.cmd 'autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete'
