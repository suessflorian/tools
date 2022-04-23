local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

require("packer").startup(function()
	use({ "wbthomason/packer.nvim" })
	use({ "ellisonleao/glow.nvim", branch = 'main' })
	use({ "navarasu/onedark.nvim" })
	use({ "akinsho/bufferline.nvim", requires = "kyazdani42/nvim-web-devicons" })
	use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })
	use({ "google/vim-jsonnet" })
	use({ "tpope/vim-commentary" })
	use({ "tpope/vim-surround" })
	use({ "williamboman/nvim-lsp-installer", requires = { "neovim/nvim-lspconfig" } })
	use({ "ruanyl/vim-gh-line" })
	use({ "romainl/vim-cool" })
	use({ "jiangmiao/auto-pairs" })
	use({ "j-hui/fidget.nvim" })
	use({ "kevinhwang91/nvim-bqf" })
	use({ "onsails/lspkind-nvim" })
	use({ "nvim-treesitter/nvim-treesitter", requires = { { "p00f/nvim-ts-rainbow" }, { "windwp/nvim-ts-autotag" } } })
	use({ "nvim-telescope/telescope.nvim", requires = { { "nvim-lua/plenary.nvim" }, { "kyazdani42/nvim-web-devicons" } } })
	use({ "L3MON4D3/LuaSnip", requires = { "rafamadriz/friendly-snippets" } })
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-buffer" },
			{ "saadparwaiz1/cmp_luasnip" },
		},
	})
	use({ "kyazdani42/nvim-tree.lua", requires = { "kyazdani42/nvim-web-devicons" } })
	use({ "petertriho/nvim-scrollbar" })

	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)

---- TODO:
-- review cmp config
-- gitsigns mappings to jump between chunks
-- review file exploration custom mappings, align with Netrw

-----------------------------------CORE
local global = vim.g
global.mapleader = " "
global.do_filetype_lua = 1 -- use filetype.lua to detect filetype

local options = vim.opt
-- TABBING
options.softtabstop = 2
options.shiftwidth = 2 -- spaces per tab (when shifting), when using the >> or << commands
options.tabstop = 2 -- spaces per tab
options.smarttab = true -- <tab>/<BS> indent/dedent in leading whitespace
options.autoindent = true -- maintain indent of current line
options.expandtab = false -- don't expand tabs into spaces
-- BACKUP
options.backup = false -- disable backup files
options.swapfile = false -- no swap files
options.autoread = true -- detect file changes outside of vim
options.undofile = true -- persistant file undo's
-- FOLDING
options.foldlevel = 5
options.foldenable = false
options.foldmethod = "expr" -- expression based folding
options.foldexpr = "nvim_treesitter#foldexpr()" -- in particular use treesitter expressions
-- APPEARANCE BEHAVIOUR
options.termguicolors = true
options.cursorline = true
options.completeopt = "menuone,noinsert" -- tweaking complete menu behaviour
options.splitright = true -- vsplits by default to the right
options.wrap = false -- disable text wrapping by default
options.linebreak = true -- if wrapping, don't break words up mid-wrap
-- MISC
options.clipboard = "unnamedplus" -- sync clipboard and default register
options.laststatus = 3 -- global status line
options.hidden = true -- allows hiding dirty buffers

-- silent key binding, optionally narrows binding scope to buffer.
local bind = function(key, func, bufnr)
	local opts = { noremap = true, silent = true }
	opts.buffer = bufnr or nil
	vim.keymap.set('n', key, func, opts)
end
-----------------------------------BLING

require("onedark").setup({ transparent = true })
require("onedark").load()
require("nvim-tree").setup({ git = { enable = false } })
require("bufferline").setup()
require("fidget").setup({ window = { blend = 0 } })
require("scrollbar").setup()

-----------------------------------GREPPING
local telescope = require('telescope.builtin')
bind("<leader>p", telescope.find_files)
bind("<leader>F", telescope.live_grep)
bind("<leader>f", telescope.grep_string)

-----------------------------------OTHER MAPPINGS
local bufferline = require("bufferline")
bind("<C-j>", function() bufferline.cycle(-1) end)
bind("<C-k>", function() bufferline.cycle(1) end)

-----------------------------------SYNTAX
local ts = require("nvim-treesitter.configs")
ts.setup({
	ensure_installed = "all",
	highlight = { enable = true },
	rainbow = { enable = true },
	autotag = { enable = true },
	indent = { enable = true },
})

-----------------------------------COMPLETION
local luasnip = require 'luasnip'
local cmp = require 'cmp'
cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end,
		['<S-Tab>'] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end,
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
}

-----------------------------------LSC
local lsc = vim.lsp
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
	server:setup({
		on_attach = function(_, bufnr)
			local buffer_bind = function(key, func) -- closure on bufnr, narrows binding scope to buffer
				bind(key, func, bufnr)
			end
			-- native LSC bindings
			buffer_bind('<C-n>', lsc.diagnostic.goto_next)
			buffer_bind('<C-p>', lsc.diagnostic.goto_prev)
			buffer_bind('K', lsc.buf.hover)
			buffer_bind('gt', lsc.buf.type_definition)
			buffer_bind('gf', lsc.buf.formatting)
			buffer_bind('gR', lsc.buf.rename)
			buffer_bind('gd', lsc.buf.declaration)

			-- telescope wrapped LSC bindings
			buffer_bind('<C-]>', telescope.lsp_definitions)
			buffer_bind('gi', telescope.lsp_implementations)
			buffer_bind('ga', telescope.lsp_code_actions)
			buffer_bind('gr', telescope.lsp_references)
			buffer_bind('gs', telescope.lsp_document_symbols)
		end,
		capabilities = require("cmp_nvim_lsp").update_capabilities(lsc.protocol.make_client_capabilities()),
	})
end)
lsc.handlers["textDocument/publishDiagnostics"] = lsc.with(lsc.diagnostic.on_publish_diagnostics, { virtual_text = false })

-----------------------------------MISC
require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_formatter_opts = { relative_time = true },
})
