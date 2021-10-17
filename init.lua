-- install packer if not present
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.api.nvim_command 'packadd packer.nvim'
end

require('packer').startup(function()
  use {'iamcco/markdown-preview.nvim'}
  use {'wbthomason/packer.nvim'}
  use {'tpope/vim-surround'}
  use {'tpope/vim-vinegar'}
  use {'nvim-treesitter/nvim-treesitter'}
  use {'neovim/nvim-lspconfig'}
  use {'kabouzeid/nvim-lspinstall'}
  use {'ruanyl/vim-gh-line'}
  use {'romainl/vim-cool'}
  use {'navarasu/onedark.nvim'}
  use {'p00f/nvim-ts-rainbow'}
  use {'cohama/lexima.vim'}
  use {'sbdchd/neoformat'}
  use {'hoob3rt/lualine.nvim'}
  use {'alvan/vim-closetag'}
  use {'mfussenegger/nvim-lint'}
  use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/plenary.nvim'}, {'kyazdani42/nvim-web-devicons'}}}
  use {'hrsh7th/cmp-nvim-lsp'}
  use {'hrsh7th/nvim-cmp'}
  use {'onsails/lspkind-nvim'}
  use {'saadparwaiz1/cmp_luasnip'}
  use {'L3MON4D3/LuaSnip'}
end)

------------------------------------- THEME -------------------------------------
vim.g.onedark_transparent_background = true
require('onedark').setup()
require('lualine').setup({options = {theme = "onedark"}})

------------------------------------ OPTIONS ------------------------------------
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
vim.opt.inccommand='nosplit' -- show effect of command incrementally
vim.opt.completeopt='menu,menuone,noselect' -- tweaking complete menu behaviour
vim.opt.mouse='a' -- let mouse do stuff
vim.opt.wrap=false -- disable text wrapping
vim.opt.undofile=true -- persistant file undo's

vim.g.closetag_filenames = '*.html,*.js*,*.ts*' -- where lexima is active
vim.g.neoformat_try_node_exe=1 -- uses project formatter dependancy if available

------------------------------------ FINDERS ------------------------------------
local actions = require "telescope.actions"
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      }
    }
  }
})
vim.api.nvim_set_keymap('n', '<leader>p', ':Telescope find_files<cr>', {noremap = true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>b', ':Telescope buffers<cr>', {noremap = true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>F', ':Telescope live_grep<cr>', {noremap = true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>f', ':Telescope grep_string<cr>', {noremap = true, silent=true})

------------------------------------ MAPPINGS -----------------------------------
vim.api.nvim_set_keymap('n', 'gf', ':Neoformat <cr>', {noremap = true, silent=true})

---------------------------------- TREE SITTER ----------------------------------
local ts = require('nvim-treesitter.configs')
ts.setup({
  ensure_installed = 'maintained',
  highlight = { enable = true },
  rainbow = { enable = true },
})

------------------------------------ LS SETUP -----------------------------------
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', '<C-n>',   ':lua vim.lsp.diagnostic.goto_next({enable_popup=false})<CR>', opts)
  buf_set_keymap('n', '<C-p>',   ':lua vim.lsp.diagnostic.goto_prev({enable_popup=false})<CR>', opts)
  buf_set_keymap('n', '<C-]>',   ':Telescope lsp_definitions<CR>', opts)
  buf_set_keymap('n', 'K',       ':lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gt',      ':lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gi',      ':Telescope lsp_implementations<CR>', opts)
  buf_set_keymap('n', 'ga',      ':Telescope lsp_code_actions<CR>', opts)
  buf_set_keymap('n', 'gR',      ':lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gd',      ':lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gr',      ':Telescope lsp_references<CR>', opts)
  buf_set_keymap('n', 'go',      ':Telescope lsp_document_symbols<CR>', opts)
end

local cmp = require('cmp')
local luasnip = require 'luasnip'
cmp.setup {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
  formatting = {
    format = require('lspkind').cmp_format({with_text = true, maxwidth = 50})
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-x><C-u>']  = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  }
}

require('lspinstall').setup()
local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup({
    on_attach = on_attach,
    indent = { enable = true },
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  })
end
-------------------------------------- MISC -------------------------------------
vim.cmd([[autocmd TextYankPost * silent! lua vim.highlight.on_yank()]]) -- highlight yank section
vim.cmd([[autocmd FocusGained,BufEnter * checktime]]) -- force file change check
vim.cmd([[autocmd BufNewFile,BufRead *.graphql set filetype=graphql]])

-------------------------------------- LINT -------------------------------------
require('lint').linters_by_ft = {go = {'golangcilint'}}
vim.cmd([[autocmd BufWritePre * :%s/\s\+$//e]])
vim.cmd([[autocmd BufEnter,BufWritePost *.go lua require('lint').try_lint() ]])
