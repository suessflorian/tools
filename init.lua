-- install packer if not present
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.api.nvim_command 'packadd packer.nvim'
end

require('packer').startup(function()
  use {'wbthomason/packer.nvim'}
  use {'numToStr/Comment.nvim'}
  use {'iamcco/markdown-preview.nvim'}
  use {'tpope/vim-surround'}
  use {'tpope/vim-vinegar'}
  use {'nvim-treesitter/nvim-treesitter'}
  use {'neovim/nvim-lspconfig'}
  use {'williamboman/nvim-lsp-installer'}
  use {'ruanyl/vim-gh-line'}
  use {'romainl/vim-cool'}
  use {'navarasu/onedark.nvim'}
  use {'p00f/nvim-ts-rainbow'}
  use {'sbdchd/neoformat'}
  use {'nvim-lualine/lualine.nvim'}
  use {'cohama/lexima.vim'}
  use {'alvan/vim-closetag'}
  use {'mfussenegger/nvim-lint'}
  use {'hrsh7th/cmp-nvim-lsp'}
  use {'hrsh7th/nvim-cmp'}
  use {'saadparwaiz1/cmp_luasnip'}
  use {'onsails/lspkind-nvim'}
  use {'L3MON4D3/LuaSnip'}
  use {'kevinhwang91/nvim-bqf'}
  use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/plenary.nvim'}, {'kyazdani42/nvim-web-devicons'}}}
end)

-----------------------------------BLING
vim.g.onedark_transparent_background = true
require('onedark').setup()
require('lualine').setup({options = {theme = "onedark"}})

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
vim.opt.inccommand='nosplit' -- show effect of command incrementally
vim.opt.completeopt='menu,menuone,noselect' -- tweaking complete menu behaviour
vim.opt.mouse='a' -- let mouse do stuff
vim.opt.wrap=false -- disable text wrapping
vim.opt.undofile=true -- persistant file undo's

vim.g.closetag_filenames = '*.html,*.js*,*.ts*' -- where lexima is active
vim.g.neoformat_try_node_exe=1 -- uses project formatter dependancy if available

local silent = { noremap=true, silent=true } -- all custom mappings will be silent

-----------------------------------GREPPING
local actions = require "telescope.actions"
function multiselect(prompt_bufnr)
    local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
    local num_selections = table.getn(picker:get_multi_selection())

    if num_selections > 1 then
        actions.send_selected_to_qflist(prompt_bufnr)
        actions.open_qflist()
    else
        actions.file_edit(prompt_bufnr)
    end
end

require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ["<CR>"] = multiselect,
      },
    },
  },
})

vim.api.nvim_set_keymap('n', '<leader>p', ':Telescope find_files<cr>', silent)
vim.api.nvim_set_keymap('n', '<leader>b', ':Telescope buffers<cr>', silent)
vim.api.nvim_set_keymap('n', '<leader>F', ':Telescope live_grep<cr>', silent)
vim.api.nvim_set_keymap('n', '<leader>f', ':Telescope grep_string<cr>', silent)

-----------------------------------OTHER MAPPINGS
vim.api.nvim_set_keymap('n', 'gf', ':Neoformat <cr>', silent)
vim.api.nvim_set_keymap('n', '<c-j>', ':cnext <cr>', silent)
vim.api.nvim_set_keymap('n', '<c-k>', ':cprevious <cr>', silent)

-----------------------------------IDE
local ts = require('nvim-treesitter.configs')
ts.setup({
  ensure_installed = 'maintained',
  highlight = { enable = true },
  rainbow = { enable = true },
})

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
  buf_set_keymap('n', 'gR',      ':lua vim.lsp.buf.rename()<CR>', silent)
  buf_set_keymap('n', 'gd',      ':lua vim.lsp.buf.declaration()<CR>', silent)
  buf_set_keymap('n', 'gr',      ':Telescope lsp_references<CR>', silent)
  buf_set_keymap('n', 'go',      ':Telescope lsp_document_symbols<CR>', silent)
end

local lsp_installer = require('nvim-lsp-installer')
lsp_installer.on_server_ready(function(server)
  server:setup({
    on_attach = ls,
    indent = { enable = true },
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  })
  vim.cmd [[ do User LspAttachBuffers ]]
end)

local cmp = require('cmp')
local luasnip = require('luasnip')
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

require('lint').linters_by_ft = {go = {'golangcilint'}}
vim.cmd([[autocmd BufEnter,BufWritePost *.go lua require('lint').try_lint() ]])

-----------------------------------MISC
require('Comment').setup()
vim.cmd([[autocmd TextYankPost * silent! lua vim.highlight.on_yank()]]) -- highlight yank section
vim.cmd([[autocmd FocusGained,BufEnter * checktime]]) -- force file change check
vim.cmd([[autocmd BufWritePre * :%s/\s\+$//e]]) -- remove trailing whitespace
