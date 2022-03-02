local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	packer_bootstrap = vim.fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

require("packer").startup(function()
	use({ "wbthomason/packer.nvim" })
	use({ "navarasu/onedark.nvim" })
	use({ "akinsho/bufferline.nvim", requires = "kyazdani42/nvim-web-devicons" })
	use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })
	use({ "google/vim-jsonnet" })
	use({ "tpope/vim-commentary" })
	use({ "iamcco/markdown-preview.nvim", run = "cd app && yarn install" })
	use({ "tpope/vim-surround" })
	use({ "williamboman/nvim-lsp-installer", requires = { "neovim/nvim-lspconfig" } })
	use({ "ruanyl/vim-gh-line" })
	use({ "jose-elias-alvarez/null-ls.nvim", requires = { "nvim-lua/plenary.nvim" } })
	use({ "romainl/vim-cool" })
	use({ "jiangmiao/auto-pairs" })
	use({ "j-hui/fidget.nvim" })
	use({ "kevinhwang91/nvim-bqf" })
	use({ "onsails/lspkind-nvim" })
	use({ "nvim-treesitter/nvim-treesitter", requires = { { "p00f/nvim-ts-rainbow" }, { "windwp/nvim-ts-autotag" } } })
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" }, { "kyazdani42/nvim-web-devicons" } },
	})
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

	if packer_bootstrap then
		require("packer").sync()
	end
end)

-----------------------------------BLING
vim.opt.termguicolors = true

require("onedark").setup({ transparent = true })
require("onedark").load()
require("nvim-tree").setup({
	git = {
		enable = false,
	},
})
require("bufferline").setup({
	options = {
		offsets = { { filetype = "NvimTree", text = "" } },
	},
})
vim.cmd([[highlight FidgetTitle ctermbg=None]])
require("fidget").setup({ window = { blend = 0 } })
require("scrollbar").setup()

-----------------------------------CORE
vim.g.mapleader = " "
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2 -- spaces per tab (when shifting), when using the >> or << commands, shift lines by 4 spaces
vim.opt.tabstop = 2 -- spaces per tab
vim.opt.smarttab = true -- <tab>/<BS> indent/dedent in leading whitespace
vim.opt.autoindent = true -- maintain indent of current line
vim.opt.expandtab = false -- don't expand tabs into spaces
vim.opt.hidden = true -- allows buffer hiding rather than abandoning
vim.opt.splitright = true -- vsplits by default to the right

vim.opt.backup = false -- disable backup files
vim.opt.swapfile = false -- no swap files
vim.opt.autoread = true -- detect file changes outside of vim

vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus" -- sync clipboard and default register
vim.opt.completeopt = "menuone,noinsert" -- tweaking complete menu behaviour
vim.opt.wrap = false -- disable text wrapping
vim.opt.undofile = true -- persistant file undo's

vim.opt.foldlevel = 5
vim.opt.foldenable = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

local map = vim.api.nvim_set_keymap
local silent = { noremap = true, silent = true } -- all custom mappings will be silent

-----------------------------------GREPPING
map("n", "<leader>p", ":Telescope find_files<cr>", silent)
map("n", "<leader>F", ":Telescope live_grep<cr>", silent)
map("n", "<leader>f", ":Telescope grep_string<cr>", silent)

-----------------------------------OTHER MAPPINGS
map("n", "<C-j>", ":BufferLineCyclePrev<cr>", silent) -- buffer rotation
map("n", "<C-k>", ":BufferLineCycleNext<cr>", silent)
map("n", "<C-x>", ":bdelete<cr>", silent) -- little controversial
map("n", "-", ":NvimTreeFindFileToggle<cr>", silent)

-----------------------------------SYNTAX
local ts = require("nvim-treesitter.configs")
ts.setup({
	ensure_installed = "maintained",
	highlight = { enable = true },
	rainbow = { enable = true },
	autotag = { enable = true },
	indent = { enable = true },
})

-----------------------------------COMPLETION
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "luasnip" },
		{ name = "buffer" },
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	formatting = {
		format = require("lspkind").cmp_format(),
	},
	mapping = {
		["<C-x><C-u>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				})
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end,
		["<S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end,
	},
	experimental = {
		ghost_text = true,
	},
})

luasnip.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
})

luasnip.snippets = {
	all = {},
	html = {},
}

-- html snippets for React
luasnip.snippets.javascript = luasnip.snippets.html
luasnip.snippets.javascriptreact = luasnip.snippets.html
luasnip.snippets.typescriptreact = luasnip.snippets.html
require("luasnip/loaders/from_vscode").load({ include = { "html" } })

-----------------------------------LSC
local nvim_lsp = require("lspconfig")
local ls = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	buf_set_keymap("n", "<C-n>", ":lua vim.lsp.diagnostic.goto_next({enable_popup=false})<cr>", silent)
	buf_set_keymap("n", "<C-p>", ":lua vim.lsp.diagnostic.goto_prev({enable_popup=false})<cr>", silent)
	buf_set_keymap("n", "<C-]>", ":Telescope lsp_definitions<cr>", silent)
	buf_set_keymap("n", "K", ":Lspsaga hover_doc<cr>", silent)
	buf_set_keymap("n", "gt", ":lua vim.lsp.buf.type_definition()<cr>", silent)
	buf_set_keymap("n", "gi", ":Telescope lsp_implementations<cr>", silent)
	buf_set_keymap("n", "gf", ":lua vim.lsp.buf.formatting()<cr>", silent)
	buf_set_keymap("n", "ga", ":Telescope lsp_code_actions<cr>", silent)
	buf_set_keymap("n", "gR", ":lua vim.lsp.buf.rename()<cr>", silent)
	buf_set_keymap("n", "gd", ":lua vim.lsp.buf.declaration()<cr>", silent)
	buf_set_keymap("n", "gr", ":Telescope lsp_references<cr>", silent)
	buf_set_keymap("n", "go", ":Telescope lsp_document_symbols<cr>", silent)
end

local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
	server:setup({
		on_attach = ls,
		capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	})
	vim.cmd([[ do User LspAttachBuffers ]])
end)

-----------------------------------LSC Auxiliary
local null_ls = require("null-ls")
null_ls.setup({
	debug = true,
	on_attach = ls,
	sources = {
		null_ls.builtins.diagnostics.eslint_d.with({ only_local = "node_modules/.bin" }),
		null_ls.builtins.formatting.eslint_d.with({ only_local = "node_modules/.bin" }),
		-- null_ls.builtins.formatting.prettier.with({ prefer_local = "node_modules/.bin" }),

		null_ls.builtins.formatting.stylua,
	},
})

-----------------------------------MISC
require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_formatter_opts = { relative_time = true },
})
vim.cmd([[autocmd FocusGained,BufEnter * checktime]]) -- force file change check
