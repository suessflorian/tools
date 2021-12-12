local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.api.nvim_command 'packadd packer.nvim'
end

require('packer').startup(function()
  use {'google/vim-jsonnet'}
  use {'wbthomason/packer.nvim'}
  use {'numToStr/Comment.nvim'}
  use {'iamcco/markdown-preview.nvim'}
  use {'tpope/vim-surround'}
  use {'tpope/vim-vinegar'}
  use {'nvim-treesitter/nvim-treesitter'}
  use {'neovim/nvim-lspconfig'}
  use {'williamboman/nvim-lsp-installer'}
  use {'ruanyl/vim-gh-line'}
  use {'navarasu/onedark.nvim'}
  use {'p00f/nvim-ts-rainbow'}
  use {'sbdchd/neoformat'}
  use {'romgrk/barbar.nvim'}
  use {'romainl/vim-cool'}
  use {'nvim-lualine/lualine.nvim'}
  use {'cohama/lexima.vim'}
  use {'alvan/vim-closetag'}
  use {'mfussenegger/nvim-lint'}
  use {'hrsh7th/vim-vsnip'}
  use {'hrsh7th/cmp-vsnip'}
  use {'hrsh7th/cmp-nvim-lsp'}
  use {'hrsh7th/cmp-path'}
  use {'hrsh7th/cmp-cmdline'}
  use {'hrsh7th/cmp-buffer'}
  use {'hrsh7th/nvim-cmp'}
  use {'onsails/lspkind-nvim'}
  use {'kevinhwang91/nvim-bqf'}
  use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/plenary.nvim'}, {'kyazdani42/nvim-web-devicons'}}}
end)

-----------------------------------BLING
vim.g.onedark_transparent_background = true
require('onedark').setup()
require('lualine').setup()

-----------------------------------CORE
vim.g.mapleader=" "

vim.opt.tabstop=2 -- number of spaces tab counts for
vim.opt.shiftwidth=2 -- size of a tab
vim.opt.expandtab=true -- spaces instead of tabs
vim.opt.shiftround=true -- round indent
vim.opt.hidden=true -- allows buffer hiding rather than abandoning

vim.opt.backup=false -- disable backup files
vim.opt.swapfile=false -- no swap files
vim.opt.autoread=true -- detect file changes outside of vim

vim.opt.cursorline=true
vim.opt.clipboard='unnamedplus' -- sync clipboard and default register
vim.opt.completeopt='menu,menuone,noselect' -- tweaking complete menu behaviour
vim.opt.mouse='a' -- let mouse do stuff
vim.opt.wrap=false -- disable text wrapping
vim.opt.undofile=true -- persistant file undo's

vim.g.closetag_filenames = '*.html,*.js*,*.ts*' -- where lexima is active
vim.g.neoformat_try_node_exe=1 -- uses project formatter dependancy if available

local map = vim.api.nvim_set_keymap
local silent = { noremap=true, silent=true } -- all custom mappings will be silent

-----------------------------------GREPPING
map('n', '<leader>p', ':Telescope find_files<cr>', silent)
map('n', '<leader>b', ':Telescope buffers<cr>', silent)
map('n', '<leader>F', ':Telescope live_grep<cr>', silent)
map('n', '<leader>f', ':Telescope grep_string<cr>', silent)

-----------------------------------OTHER MAPPINGS
map('n', 'gf',    ':Neoformat <cr>', silent)
map('n', '<C-h>', ':cprev<CR>', silent) -- quickfix rotation
map('n', '<C-l>', ':cnext<CR>', silent)
map('n', '<C-j>', ':BufferPrevious<CR>', silent) -- buffer rotation
map('n', '<C-k>', ':BufferNext<CR>', silent)
map('n', '<C-x>', ':BufferClose<CR>', silent) -- little controversial

-----------------------------------SYNTAX
local ts = require('nvim-treesitter.configs')
ts.setup({
  ensure_installed = 'maintained',
  highlight = { enable = true },
  rainbow = { enable = true },
})

-----------------------------------COMPLETION
local cmp = require('cmp')
cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'vsnip' },
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-x><C-u>']  = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
    ['<CR>'] = cmp.mapping.confirm({select = true}),
  }
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-----------------------------------LSC
local nvim_lsp = require('lspconfig')
local ls = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  buf_set_keymap('n', '<C-n>',   ':lua vim.lsp.diagnostic.goto_next({enable_popup=false})<CR>', silent)
  buf_set_keymap('n', '<C-p>',   ':lua vim.lsp.diagnostic.goto_prev({enable_popup=false})<CR>', silent)
  buf_set_keymap('n', '<C-]>',   ':Telescope lsp_definitions<CR>', silent)
  buf_set_keymap('n', 'K',       ':lua vim.lsp.buf.hover()<CR>', silent)
  buf_set_keymap('n', 'gt',      ':lua vim.lsp.buf.type_definition()<CR>', silent)
  buf_set_keymap('n', 'gi',      ':Telescope lsp_implementations<CR>', silent)
  buf_set_keymap('n', 'ga',      ':lua vim.lsp.buf.code_action()<CR>', silent)
  buf_set_keymap('n', 'ga',      ':Telescope lsp_code_actions<CR>', silent)
  buf_set_keymap('n', 'gR',      ':lua vim.lsp.buf.rename()<CR>', silent)
  buf_set_keymap('n', 'gd',      ':lua vim.lsp.buf.declaration()<CR>', silent)
  buf_set_keymap('n', 'gr',      ':Telescope lsp_references<CR>', silent)
  buf_set_keymap('n', 'go',      ':Telescope lsp_document_symbols<CR>', silent)
end

local lsp_installer = require('nvim-lsp-installer')
lsp_installer.on_server_ready(function(server)
  server:setup({
    on_attach = ls,
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  })
  vim.cmd [[ do User LspAttachBuffers ]]
end)

-----------------------------------MISC
require('lint').linters_by_ft = {go = {'golangcilint'}}
vim.cmd([[autocmd BufEnter,BufWritePost *.go lua require('lint').try_lint() ]])

require('Comment').setup()
vim.cmd([[autocmd TextYankPost * silent! lua vim.highlight.on_yank()]]) -- highlight yank section
vim.cmd([[autocmd FocusGained,BufEnter * checktime]]) -- force file change check
vim.cmd([[autocmd BufWritePre * :%s/\s\+$//e]]) -- remove trailing whitespace
