-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-textobjects")

	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")

	use("jose-elias-alvarez/null-ls.nvim")
	use("jayp0521/mason-null-ls.nvim")

	-- Autopairs
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	-- Color themes
	use({ "catppuccin/nvim", as = "catppuccin" })

	-- LSP
	use("neovim/nvim-lspconfig")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-nvim-lsp")

	use({
		"karloskar/poetry-nvim",
		config = function()
			require("poetry-nvim").setup()
		end,
	})

	-- Rust
	use("simrat39/rust-tools.nvim")

	-- clangd
	use("p00f/clangd_extensions.nvim")

	-- Motions
	use({
		"phaazon/hop.nvim",
		branch = "v2", -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require("hop").setup()
		end,
	})

	-- Debugging
	use("mfussenegger/nvim-dap")
	use("rcarriga/nvim-dap-ui")
	use("theHamsta/nvim-dap-virtual-text")
	use("nvim-telescope/telescope-dap.nvim")

	-- Icons
	use("kyazdani42/nvim-web-devicons")

	-- Tree
	use({
		"kyazdani42/nvim-tree.lua",
		requires = { "kyazdani42/nvim-web-devicons" },
		after = "nvim-web-devicons",
		config = function()
			require("nvim-tree").setup()
		end,
	})

	-- Fuzzyfinding
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	use("jremmen/vim-ripgrep")

	--Toggleterm
	use("akinsho/toggleterm.nvim")

	-- Glorious vimtex
	use("lervag/vimtex")

	use("preservim/vim-markdown")

	use({
		"aspeddro/pandoc.nvim",
		config = function()
			require("pandoc").setup()
		end,
	})

	-- Motions
	use("tpope/vim-surround")
	use("cherryman/vim-commentary-yank")

	-- Snippets
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")

	-- Start pages
	use({
		"startup-nvim/startup.nvim",
		requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			require("startup").setup({ theme = "evil" })
		end,
	})

	-- I am
	use("lewis6991/impatient.nvim")

	-- Blame people
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	})

	-- Obsidian
	use({
		"epwalsh/obsidian.nvim",
		requires = {
			-- Required.
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("obsidian").setup({
				dir = "~/Documents/Obsidian Vault",
				-- Optional, completion.
				completion = {
					-- If using nvim-cmp, otherwise set to false
					nvim_cmp = true,
					-- Trigger completion at 2 chars
					min_chars = 2,
					-- Where to put new notes created from completion. Valid options are
					--  * "current_dir" - put new notes in same directory as the current buffer.
					--  * "notes_subdir" - put new notes in the default notes subdirectory.
					new_notes_location = "current_dir",
					prepend_note_id = false,
				},

				mappings = {
					["gf"] = require("obsidian.mapping").gf_passthrough(),
				},

				-- Optional, set to true if you don't want obsidian.nvim to manage frontmatter.
				disable_frontmatter = true,
			})
		end,
	})

	-- Jupyter notebooks
	use({
		"dccsillag/magma-nvim",
		run = ":UpdateRemotePlugins",
		config = function()
			vim.keymap.set("n", "<leader>r", ":MagmaEvaluateOperator<CR>", { silent = true })
			vim.keymap.set("n", "<leader>rr", ":MagmaEvaluateLine<CR>", { silent = true })
			vim.keymap.set("x", "<leader>r", ":<C-u>MagmaEvaluateVisual<CR>", { silent = true })
			vim.keymap.set("n", "<leader>c", ":MagmaReevaluateCell<CR>", { silent = true })
			vim.keymap.set("n", "<leader>d", ":MagmaDelete<CR>", { silent = true })
			vim.keymap.set("n", "<leader>o", ":MagmaShowOutput<CR>", { silent = true })

			vim.g.magma_automatically_open_output = false
			vim.g.magma_image_provider = "kitty"
		end,
	})

	use({
		"edluffy/hologram.nvim",
		config = function()
			require("hologram").setup({
				auto_display = true, -- WIP automatic markdown image display, may be prone to breaking
			})
		end,
	})
end)
