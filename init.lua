local vim = vim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local global = vim.g
global.mapleader = " " -- space

-- NOTE: as per nvim-tree/nvim-tree advice, we can disable netrw in the following way
global.loaded = 1
global.loaded_netrwPlugin = 1

require("lazy").setup({
	"norcalli/nvim-colorizer.lua",
	"lervag/vimtex",
	"lewis6991/impatient.nvim",
	"RRethy/vim-illuminate",
	"folke/tokyonight.nvim",
	"tpope/vim-commentary",
	"tpope/vim-surround",
	"tpope/vim-sleuth",
	"ruanyl/vim-gh-line",
	"kevinhwang91/nvim-bqf",
	"romainl/vim-cool",
	"onsails/lspkind-nvim",
	{ "kevinhwang91/nvim-ufo",   dependencies = "kevinhwang91/promise-async" },
	{ "akinsho/bufferline.nvim", dependencies = "kyazdani42/nvim-web-devicons" },
	{ "lewis6991/gitsigns.nvim", dependencies = "nvim-lua/plenary.nvim" },
	{ "nvim-tree/nvim-tree.lua", dependencies = "kyazdani42/nvim-web-devicons" },
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = { "p00f/nvim-ts-rainbow", "windwp/nvim-ts-autotag" },
		build = ":TSUpdate"
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" } }
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-cmdline",
			"zbirenbaum/copilot-cmp",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end
	},
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end
	},
	{
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	},
	{
		"windwp/nvim-autopairs", event = "InsertEnter", opts = {} -- this is equalent to setup({}) function
	},
	{ "stefanlogue/hydrate.nvim",            opts = { persist_timer = true } },
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl",                   opts = {} },
})

require("impatient")

-----------------------------------DEPENDANCY-MANAGEMENT
require("mason").setup()

---- TODO:
-- telescope buffer management
-- new window behaviour in Kitty weird
-- move to nvim surround ? over tpope

-----------------------------------CORE
local options = vim.opt
-- TABBING
options.tabstop = 2      -- spaces per tab
-- BACKUP
options.backup = false   -- disable backup files
options.swapfile = false -- no swap files
options.undofile = true  -- persistent file undo"s
-- FOLDING
options.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
options.foldcolumn = "0" -- hide for now, waiting on https://github.com/neovim/neovim/pull/17446
options.foldlevel = 99
options.foldenable = true
-- APPEARANCE BEHAVIOUR
options.cursorline = true
options.completeopt = "menu,menuone,noselect" -- recommended by cmp
options.splitright = true                     -- vsplits by default to the right
options.wrap = false                          -- disable text wrapping by default
options.linebreak = true                      -- if wrapping, don"t break words up mid-wrap
-- MISC
options.clipboard = "unnamedplus"             -- sync clipboard and default register
options.laststatus = 3                        -- global status line
options.scrolloff = 3                         -- always have lines bellow cursor line
options.ignorecase = true                     -- case insensitive searching UNLESS /C or capital in search
options.smartcase = true
options.jumpoptions = "stack"
options.mouse = "a"
options.nu = true
options.termguicolors = true

-- silent key binding, optionally pass additional options
local bind = function(key, func, opts)
	opts = opts or {}
	opts.noremap, opts.silent = true, true
	vim.keymap.set("n", key, func, opts)
end

-- remap for dealing with word wrap
bind("k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
bind("j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-----------------------------------BLING
require("tokyonight").setup({ transparent = true })
require("colorizer").setup()
vim.cmd [[colorscheme tokyonight-storm]]
require("nvim-tree").setup({ git = { enable = false } })
require("bufferline").setup()
require("ibl").setup()

-------------------------------------GREPPING
require("telescope").load_extension("fzf")
local telescope = require("telescope.builtin")
bind("<leader>p", telescope.find_files)
bind("<leader>P", telescope.git_files)
bind("<leader>b", telescope.buffers)
bind("<leader>F", telescope.live_grep)
bind("<leader>f", telescope.grep_string)

-----------------------------------OTHER MAPPINGS
local bufferline = require("bufferline")
bind("<C-j>", function() bufferline.cycle(-1) end)
bind("<C-k>", function() bufferline.cycle(1) end)

local api = require("nvim-tree.api")
bind("-", function() api.tree.toggle({ find_file = true }) end)

vim.cmd [[tnoremap <silent> <Esc> <C-\><C-n>]]

-----------------------------------SYNTAX
vim.defer_fn(function()
	require("nvim-treesitter.configs").setup({
		ensure_installed = { "go", "lua", "python", "tsx", "javascript", "typescript", "vimdoc", "vim", "bash",
			"comment" },
		ignore_install = { "latex" },
		highlight = { enable = true },
		rainbow = { enable = true },
		autotag = { enable = true },
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<c-space>",
				node_incremental = "<c-space>",
			},
		},
	})
end, 0)

-----------------------------------COMPLETION
local cmp = require "cmp"
local luasnip = require "luasnip"
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup {}

require("copilot").setup()

cmp.setup {
	formatting = {
		format = require("lspkind").cmp_format({
			mode = "symbol",    -- show only symbol annotations
			maxwidth = 50,      -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
			ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
		})
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-x><C-u>"] = cmp.mapping.complete {},
		["<CR>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "copilot" },
	},
}

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({ { name = "cmdline" } })
})

-----------------------------------LSC
require("mason-lspconfig").setup()
local lsc = vim.lsp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single", max_width = 80 })

require("mason-lspconfig").setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			on_attach = function(_, bufnr)
				local buffer_bind = function(key, func)
					bind(key, func, { buffer = bufnr })
				end
				buffer_bind("<C-n>", vim.diagnostic.goto_next)
				buffer_bind("<C-p>", vim.diagnostic.goto_prev)
				buffer_bind("K", lsc.buf.hover)
				buffer_bind("gf", function() lsc.buf.format { async = true } end)
				buffer_bind("gR", lsc.buf.rename)
				buffer_bind("gd", lsc.buf.declaration)
				buffer_bind("ga", lsc.buf.code_action)

				buffer_bind("<C-]>", telescope.lsp_definitions)
				buffer_bind("gt", telescope.lsp_type_definitions)
				buffer_bind("gi", telescope.lsp_implementations)
				buffer_bind("gr", telescope.lsp_references)
				buffer_bind("gs", telescope.lsp_document_symbols)
			end,
			capabilities = capabilities,
		})
	end,
})

bind("]]", function() require("illuminate").goto_next_reference(true) end)
bind("[[", function() require("illuminate").goto_prev_reference(true) end)

require("ufo").setup({
	provider_selector = function(_, _, _)
		return { "treesitter", "indent" }
	end
})

-----------------------------------MISC
local gitsigns = require("gitsigns")
gitsigns.setup({
	current_line_blame = true,
	current_line_blame_formatter_opts = { relative_time = true },
	on_attach = function(bufnr)
		local buffer_bind = function(key, func)
			bind(key, func, { buffer = bufnr })
		end
		buffer_bind("]c", gitsigns.next_hunk)
		buffer_bind("[c", gitsigns.prev_hunk)
	end
})

-- we"ll etch this into another plugin
-- what we"re doing is managing the buffer list
-- by performing a prune
-- basically we unlist/unload buffers if they haven"t been
-- touched. This allows rapid cycling through buffers
-- via goto def for example, without polluting the buffer list
-- we only persist buffers that are touched.
local id = vim.api.nvim_create_augroup("startup", { clear = false })

vim.api.nvim_create_autocmd({ "BufRead" }, {
	group = id,
	pattern = { "*" },
	callback = function()
		vim.api.nvim_create_autocmd({ "InsertEnter", "BufModifiedSet" }, {
			buffer = 0,
			once = true,
			callback = function()
				vim.fn.setbufvar(vim.api.nvim_get_current_buf(), "bufpersist", 1)
			end
		})
	end
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = id,
	pattern = { "*" },
	callback = function()
		local curbufnr = vim.api.nvim_get_current_buf()
		if vim.api.nvim_buf_get_option(curbufnr, "buftype") ~= "" then
			return
		end

		local is_buffer_in_view = function(bufnr)
			for _, win_id in ipairs(vim.api.nvim_list_wins()) do
				if vim.api.nvim_win_get_buf(win_id) == bufnr then
					return true
				end
			end
			return false
		end

		-- deciding which buffers to prune
		for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			if not vim.api.nvim_buf_get_option(bufnr, "buflisted") or is_buffer_in_view(bufnr) then
				goto continue
			end

			if vim.api.nvim_buf_get_option(bufnr, "modified") then
				vim.fn.setbufvar(bufnr, "bufpersist", 1)
				goto continue
			end

			if vim.fn.getbufvar(bufnr, "bufpersist") ~= 1 then
				vim.cmd("bd " .. tostring(bufnr))
			end
			::continue::
		end
	end
})
