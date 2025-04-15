-- This file can be loaded by calling `lua require('plugins')` from your init.vim
local plugins = {
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", enabled = true },
	{ "nvim-treesitter/nvim-treesitter-textobjects", enabled = true },

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				panel = {
					auto_refresh = true,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<CR>",
						refresh = "gr",
						-- open = "<Space>cp",
					},
					layout = {
						position = "right", -- | top | left | right | horizontal | vertical
						ratio = 0.3,
					},
				},
				suggestion = {
					keymap = {
						accept = "<C-l>",
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
			})
		end,
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = true,
		version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
		opts = {
			-- add any opts here
			-- for example
			provider = "copilot",
			copilot = {
				endpoint = "https://api.githubcopilot.com",
				-- model = "claude-3.7-sonnet",
				-- model = "gpt-4o",
				-- proxy = nil, -- [protocol://]host[:port] Use this proxy
				-- allow_insecure = false, -- Allow insecure server connections
				-- timeout = 30000, -- Timeout in milliseconds
				-- temperature = 0,
				-- max_tokens = 8192,
			},
			vendors = {
				copilot_claude = {
					__inherited_from = "copilot",
					model = "claude-3.7-sonnet",
				},
				copilot_claude_thinking = {
					__inherited_from = "copilot",
					model = "claude-3.7-sonnet-thought",
				},
				-- Available
				copilot_o1 = {
					__inherited_from = "copilot",
					model = "o1",
				},
				-- Available
				copilot_o3_mini = {
					__inherited_from = "copilot",
					model = "o3-mini",
				},
				copilot_4o = {
					__inherited_from = "copilot",
					model = "gpt-4o",
				},
			},
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"echasnovski/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},

	-- New formatting
	{
		"stevearc/conform.nvim",
		opts = {},
	},

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

	{ "ziglang/zig.vim" },

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},

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

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
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
		enabled = false,
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
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			preset = "helix",
			delay = 500,
			triggers = {
				{ "<auto>", mode = "nixsotc" },
				{ "a", mode = { "n", "v" } },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
}

local opts = {}
require("lazy").setup(plugins, opts)
