-- This file can be loaded by calling `lua require('plugins')` from your init.vim
local plugins = {
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", enabled = true },
	{ "nvim-treesitter/nvim-treesitter-textobjects", enabled = true },
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true,
				multiline_threshold = 12,
			})
		end,
	},
	{
		"mrcjkb/haskell-tools.nvim",
		version = "^6", -- Recommended
		lazy = false, -- This plugin is already lazy
	},
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
			providers = {
				copilot = {
					endpoint = "https://api.githubcopilot.com",
					model = "gpt-4o",
					extra_request_body = {
						temperature = 0,
						max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
						reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
					},
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
	{
		"m4xshen/hardtime.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {},
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
	{ "lervag/vimtex", ft = { "tex", "latex", "markdown" } },

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

	"preservim/vim-markdown",

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

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	},
	{
		"folke/zen-mode.nvim",
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

	{
		"vhyrro/luarocks.nvim",
		priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
		opts = {
			rocks = { "lua-cjson" }, -- specifies a list of rocks to install
		},
	},

	-- Obsidian
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "vault",
					path = "~/Documents/Obsidian Vault",
				},
			},
			notes_subdir = "05 - Fleeting",
			daily_notes = {
				folder = "06 - Daily",
				alias_format = "%B %-d, %Y",
				-- Optional, default tags to add to each new daily note created.
				default_tags = { "daily" },
				-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
				template = "nvim-daily.md",
			},
			templates = {
				folder = "99 - Meta",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
				-- A map for custom variables, the key should be the variable and the value a function
				substitutions = {
					yesterday = function()
						return os.date("%Y-%m-%d", os.time() - 86400)
					end,
					today = function()
						return os.date("%Y-%m-%d", os.time())
					end,
					tomorrow = function()
						return os.date("%Y-%m-%d", os.time() + 86400)
					end,
					["day-today"] = function()
						return os.date("%A, %b %e %Y", os.time())
					end,
					eow = function()
						local hand = assert(io.popen([[date "+%Y%m%d" -d Sun]], "r"))
						local res = assert(hand:read("*a"))
						hand:close()
						return res
					end,
					quote = function()
						local json = require("cjson")
						local hand = assert(io.popen("curl https://zenquotes.io/api/today | jq '.[0]'", "r"))
						local res = assert(hand:read("*a"))
						hand:close()

						res = json.decode(res)

						return "> [!quote] " .. res.q .. "\n> -- " .. res.a
						-- return "> [!quote] Do or do not. There is no try\n> -- Yoda"
					end,
				},
			},
			ui = { enable = false },
			disable_frontmatter = true,
		},
	},

	{
		"quarto-dev/quarto-nvim",
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
}

local opts = {}
require("lazy").setup(plugins, opts)
