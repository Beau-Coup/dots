-- This file can be loaded by calling `lua require('plugins')` from your init.vim
local plugins = {
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	"nvim-treesitter/nvim-treesitter-textobjects",
	-- "williamboman/mason.nvim",
	-- "williamboman/mason-lspconfig.nvim",
	{ "github/copilot.vim", cmd = "Copilot" },

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
	{ "mfussenegger/nvim-dap", dependencies = { "nvim-neotest/nvim-nio" } },
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

	-- lazy.nvim
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = true, -- add a border to hover docs and signature help
				},
			})
			require("notify").setup({
				background_colour = "#000000",
			})
		end,
	},
	-- Rust
	{ "mrcjkb/rustaceanvim" },

	-- Work with plebs on overleaf
	{ "subnut/nvim-ghost.nvim" },

	-- See the math
	{
		"vhyrro/luarocks.nvim",
		priority = 1001, -- this plugin needs to run before anything else
		opts = {
			rocks = { "magick", "jsregexp" },
		},
	},
	-- {
	-- 	"3rd/image.nvim",
	-- 	config = function()
	-- 		require("image").setup()
	-- 	end,
	-- },

	-- Org mode
	{
		"nvim-neorg/neorg",
		lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
		version = "*", -- Pin Neorg to the latest stable release
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {},
					["core.keybinds"] = {
						config = {
							default_keybinds = true,
						},
					},
					["core.concealer"] = {},
					["core.dirman"] = {
						config = {
							workspaces = {
								notes = "~/neorg/notes",
							},
						},
					},
					["core.completion"] = {
						config = {
							engine = "nvim-cmp",
						},
					},
					["core.integrations.nvim-cmp"] = {},
					-- ["core.integrations.image"] = {},
					-- ["core.latex.renderer"] = {},
				},
			})
			return true
		end,
	},

	-- Obsidian
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter",
		},
		opts = {
			disable_frontmatter = true,
			workspaces = {
				{
					name = "work",
					path = "~/Documents/Obsidian Vault",
				},
			},
		},
	},
}

local opts = {}
require("lazy").setup(plugins, opts)
