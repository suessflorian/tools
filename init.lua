local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function()
	use {'wbthomason/packer.nvim'}
	use {'navarasu/onedark.nvim'}
	use {'nvim-lualine/lualine.nvim'}
	use {'romgrk/barbar.nvim', requires = {
		{'kyazdani42/nvim-web-devicons'},
	}}
	use { 'lewis6991/gitsigns.nvim', requires = {
		'nvim-lua/plenary.nvim' }
	}
	use {'google/vim-jsonnet'}
	use {'tpope/vim-commentary'}
	use {'iamcco/markdown-preview.nvim',
		run = 'cd app && yarn install',
	}
	use {'tpope/vim-surround'}
	use {'tpope/vim-vinegar'}
	use {'williamboman/nvim-lsp-installer', requires = {
		{'neovim/nvim-lspconfig'},
	}}
	use {'ruanyl/vim-gh-line'}
	use {'sbdchd/neoformat'}
	use {'romainl/vim-cool'}
	use {'jiangmiao/auto-pairs'}
	use {'mfussenegger/nvim-lint'}
	use {'kevinhwang91/nvim-bqf'}
	use {'nvim-treesitter/nvim-treesitter', requires = {
		{'p00f/nvim-ts-rainbow'},
		{'windwp/nvim-ts-autotag'},
	}}
	use {'hrsh7th/nvim-cmp', requires = {
		{'hrsh7th/vim-vsnip'},
		{'hrsh7th/cmp-vsnip'},
		{'hrsh7th/cmp-nvim-lsp'},
		{'hrsh7th/cmp-path'},
		{'hrsh7th/cmp-cmdline'},
		{'hrsh7th/cmp-buffer'},
	}}
	use {'nvim-telescope/telescope.nvim', requires = {
		{'nvim-lua/plenary.nvim'},
		{'kyazdani42/nvim-web-devicons'},
	}}

	if packer_bootstrap then
		require('packer').sync()
	end
end)


-----------------------------------BLING
vim.opt.termguicolors=true
vim.g.onedark_transparent_background=true
require('onedark').setup()
require('lualine').setup()

-----------------------------------CORE
vim.g.mapleader=" "
vim.opt.tabstop=4
vim.opt.shiftwidth=4
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

vim.g.neoformat_try_node_exe=1 -- uses project formatter dependancy if available

local map = vim.api.nvim_set_keymap
local silent = { noremap=true, silent=true } -- all custom mappings will be silent

-----------------------------------GREPPING
map('n', '<leader>p', ':Telescope find_files<cr>', silent)
map('n', '<leader>b', ':Telescope buffers<cr>', silent)
map('n', '<leader>F', ':Telescope live_grep<cr>', silent)
map('n', '<leader>f', ':Telescope grep_string<cr>', silent)
map('n', '<leader>r', ':Telescope registers<cr>', silent)

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
	highlight = { enable = true},
	rainbow = { enable = true},
	autotag = { enable = true},
	indent = { enable = true},
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
		['<C-x><C-u>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
		['<TAB>'] = cmp.mapping.confirm({select = true}),
	},
	experimental = {
		ghost_text = true
	}
})

cmp.setup.cmdline(':', {
	sources = cmp.config.sources({
		{ name = 'path' }
	},{
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
require('gitsigns').setup({
	current_line_blame = true,
	current_line_blame_opts = {
    	virt_text_pos = 'right_align',
  	},
})
require('lint').linters_by_ft = {go = {'golangcilint'}}
vim.cmd([[autocmd BufEnter,BufWritePost *.go lua require('lint').try_lint() ]])
vim.cmd([[autocmd FocusGained,BufEnter * checktime]]) -- force file change check
vim.cmd([[autocmd BufWritePre * :%s/\s\+$//e]]) -- remove trailing whitespace
