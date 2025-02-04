local vim = vim
vim.loader.enable()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local global = vim.g
global.mapleader = " "

-- prevent netrw from loading.
global.loaded_netrw = 1
global.loaded_netrwPlugin = 1

require("lazy").setup({
  { "nvim-treesitter/nvim-treesitter",        build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "projekt0n/github-nvim-theme" },
  { "RRethy/vim-illuminate" },
  { "tpope/vim-surround" },
  { "ruanyl/vim-gh-line" },
  { "onsails/lspkind-nvim" },
  { "HiPhish/rainbow-delimiters.nvim" },
  { "windwp/nvim-ts-autotag" },
  { "kevinhwang91/nvim-ufo",                  dependencies = { "kevinhwang91/promise-async" } },
  { "lewis6991/gitsigns.nvim",                dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-tree/nvim-tree.lua",                dependencies = { "kyazdani42/nvim-web-devicons" } },
  { "nvim-telescope/telescope.nvim",          dependencies = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons" }, },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  { "windwp/nvim-autopairs" },
  { "lukas-reineke/indent-blankline.nvim" },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",
    },
  },
})

-----------------------------------DEPENDENCY-MANAGEMENT
require("mason").setup()

-----------------------------------CORE
require("github-theme").setup({ options = { transparent = true, }, })
require("github-theme").load()
require("nvim-autopairs").setup()

local options = vim.opt
-- TABBING
options.tabstop = 2
-- BACKUP
options.backup = false
options.swapfile = false
options.undofile = true
-- FOLDING
options.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
options.foldcolumn = "0"
options.foldlevel = 99
options.foldlevelstart = 99
options.foldenable = true
-- APPEARANCE BEHAVIOUR
options.cursorline = true
options.completeopt = "menu,menuone,noselect" -- recommended by cmp
options.splitright = true
options.wrap = false
options.linebreak = true
-- MISC
options.clipboard = "unnamedplus"
options.laststatus = 3
options.scrolloff = 3
options.ignorecase = true
options.smartcase = true
options.jumpoptions = "stack"
options.mouse = "a"
options.number = true
options.conceallevel = 2
-- INDENT
vim.opt.tabstop = 2      -- number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 2   -- number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- use spaces instead of tabs

local bind = function(key, func, opts)
  opts = opts or {}
  opts.noremap, opts.silent = true, true
  vim.keymap.set("n", key, func, opts)
end

-------------------------------------GREPPING
local telescope = require("telescope.builtin")
bind("<leader>p", telescope.find_files)
bind("<leader>P", telescope.git_files)
bind("<leader>b", telescope.buffers)
bind("<leader>F", telescope.live_grep)
bind("<leader>f", telescope.grep_string)
bind("<leader>/", telescope.current_buffer_fuzzy_find)
vim.keymap.set("c", "<leader>r", telescope.command_history)

-----------------------------------OTHER MAPPINGS
local api = require("nvim-tree.api")
bind("-", function() api.tree.toggle({ find_file = true }) end)

-----------------------------------SYNTAX
require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-space>",
      node_incremental = "<c-space>",
    },
  },
})

require("nvim-ts-autotag").setup()

-----------------------------------COMPLETION
local cmp = require "cmp"
local luasnip = require "luasnip"
luasnip.config.setup {}

cmp.setup {
  formatting = {
    format = require("lspkind").cmp_format({})
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
    ["<CR>"] = cmp.mapping.confirm { select = true },
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
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
        --:h lsp-defaults re; <C-]>, gq, K
        buffer_bind("gf", function() lsc.buf.format { async = true } end)
        buffer_bind("gR", lsc.buf.rename)
        buffer_bind("gd", lsc.buf.declaration)
        buffer_bind("ga", lsc.buf.code_action)

        buffer_bind("gt", telescope.lsp_type_definitions)
        buffer_bind("gi", telescope.lsp_implementations)
        buffer_bind("gr", telescope.lsp_references)
        buffer_bind("gs", telescope.lsp_document_symbols)
        buffer_bind("gS", telescope.lsp_dynamic_workspace_symbols)
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

-----------------------------------GIT
-- :h vim-gh-line re; go, gh, gb
local gitsigns = require("gitsigns")
gitsigns.setup({
  on_attach = function(bufnr)
    local buffer_bind = function(key, func)
      bind(key, func, { buffer = bufnr })
    end
    buffer_bind("]c", gitsigns.next_hunk)
    buffer_bind("[c", gitsigns.prev_hunk)
  end
})

-----------------------------------MISC
require("ibl").setup()
require("nvim-tree").setup({ git = { enable = false } })
