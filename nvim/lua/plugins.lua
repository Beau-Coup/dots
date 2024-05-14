-- This file can be loaded by calling `lua require('plugins')` from your init.vim
local plugins = {
	{ "nvim-treesitter/nvim-treesitter", 
        build = ":TSUpdate",
	 },
	"nvim-treesitter/nvim-treesitter-textobjects",
	-- "williamboman/mason.nvim",
	-- "williamboman/mason-lspconfig.nvim",
    "github/copilot.vim",

	"jose-elias-alvarez/null-ls.nvim",
	"jayp0521/mason-null-ls.nvim",

	-- Autopairs
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	-- Color themes
	{ "catppuccin/nvim", name = "catppuccin" },

	-- LSP
	"neovim/nvim-lspconfig",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-nvim-lsp",

	{
		"karloskar/poetry-nvim",
		config = function()
			require("poetry-nvim").setup()
		end,
	},

	-- clangd
	"p00f/clangd_extensions.nvim",

	-- Motions
	{
		"phaazon/hop.nvim",
		branch = "v2", -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require("hop").setup()
		end,
	},

	-- Debugging
	{"mfussenegger/nvim-dap", dependencies = {"nvim-neotest/nvim-nio"}},
	"rcarriga/nvim-dap-ui",
	"theHamsta/nvim-dap-virtual-text",
	"nvim-telescope/telescope-dap.nvim",

	-- Icons
	"kyazdani42/nvim-web-devicons",

	-- Tree
	{
		"kyazdani42/nvim-tree.lua",
		dependencies = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup()
		end,
	},

	-- Fuzzyfinding
	"nvim-lua/popup.nvim",
	"nvim-lua/plenary.nvim",
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	"jremmen/vim-ripgrep",

	--Toggleterm
	"akinsho/toggleterm.nvim",

	-- Glorious vimtex
	"lervag/vimtex",

	"preservim/vim-markdown",

	{
		"aspeddro/pandoc.nvim",
		config = function()
			require("pandoc").setup()
		end,
	},

	-- Motions
	"tpope/vim-surround",
	"cherryman/vim-commentary-yank",

	-- Snippets
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",

	-- Start pages
	{
		"startup-nvim/startup.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			require("startup").setup({ theme = "evil" })
		end,
	},

	-- I am
	"lewis6991/impatient.nvim",

	-- Blame people
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- Rust
	{ "mrcjkb/rustaceanvim", ft = { "rust" } },

	-- Obsidian
	{
		"epwalsh/obsidian.nvim",
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("obsidian").setup({
				dir = "~/Documents/Obsidian Vault",
				-- Optional, completion.
				mappings = {
					["gf"] = require("obsidian").util.gf_passthrough(),
				},
				ui = {
					enable = false,
				},
				-- Optional, set to true if you don't want obsidian.nvim to manage frontmatter.
				disable_frontmatter = true,
			})
		end,
	},
}

local opts = {}
require("lazy").setup(plugins, opts)
