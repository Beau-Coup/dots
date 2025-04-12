-- vim.opt.runtimepath:append("$HOME/.local/share/nvim/lazy/nvim-treesitter")

-- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
--
-- parser_config.ziggy = {
-- 	install_info = {
-- 		url = "https://github.com/kristoff-it/ziggy",
-- 		includes = { "tree-sitter-ziggy/src" },
-- 		files = { "tree-sitter-ziggy/src/parser.c" },
-- 		branch = "main",
-- 		generate_requires_npm = false,
-- 		requires_generate_from_grammar = false,
-- 	},
-- 	filetype = "ziggy",
-- }
--
-- parser_config.ziggy_schema = {
-- 	install_info = {
-- 		url = "https://github.com/kristoff-it/ziggy",
-- 		files = { "tree-sitter-ziggy-schema/src/parser.c" },
-- 		branch = "main",
-- 		generate_requires_npm = false,
-- 		requires_generate_from_grammar = false,
-- 	},
-- 	filetype = "ziggy-schema",
-- }
--
-- parser_config.supermd = {
-- 	install_info = {
-- 		url = "https://github.com/kristoff-it/supermd",
-- 		includes = { "tree-sitter/supermd/src" },
-- 		files = {
-- 			"tree-sitter/supermd/src/parser.c",
-- 			"tree-sitter/supermd/src/scanner.c",
-- 		},
-- 		branch = "main",
-- 		generate_requires_npm = false,
-- 		requires_generate_from_grammar = false,
-- 	},
-- 	filetype = "supermd",
-- }
--
-- parser_config.supermd_inline = {
-- 	install_info = {
-- 		url = "https://github.com/kristoff-it/supermd",
-- 		includes = { "tree-sitter/supermd-inline/src" },
-- 		files = {
-- 			"tree-sitter/supermd-inline/src/parser.c",
-- 			"tree-sitter/supermd-inline/src/scanner.c",
-- 		},
-- 		branch = "main",
-- 		generate_requires_npm = false,
-- 		requires_generate_from_grammar = false,
-- 	},
-- 	filetype = "supermd_inline",
-- }
--
-- parser_config.superhtml = {
-- 	install_info = {
-- 		url = "https://github.com/kristoff-it/superhtml",
-- 		includes = { "tree-sitter-superhtml/src" },
-- 		files = {
-- 			"tree-sitter-superhtml/src/parser.c",
--			"tree-sitter-superhtml/src/scanner.c",
-- 		},
-- 		branch = "main",
-- 		generate_requires_npm = false,
-- 		requires_generate_from_grammar = false,
-- 	},
-- 	filetype = "superhtml",
-- }

vim.filetype.add({
	extension = {
		smd = "supermd",
		shtml = "superhtml",
		ziggy = "ziggy",
		["ziggy-schema"] = "ziggy_schema",
	},
})

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"rust",
		"lua",
		"python",
		"c",
		-- "zig",
		"vim",
        "vimdoc",
		"toml",
		-- "ziggy",
		-- "ziggy_schema",
		-- "supermd",
		-- "superhtml",
		"markdown",
	},
	sync_install = false,
	auto_install = true,
	-- parser_install_dir = "$HOME/.local/share/nvim/lazy/nvim-treesitter",
	ignore_install = {},
	highlight = {
		enable = true,
		disable = { "latex", "lua" },
	},
	textobjects = {
		select = {
			enable = true,
			include_surrounding_whitespace = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ab"] = "@block.outer",
				["ib"] = "@block.inner",
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["al"] = "@loop.outer",
				["il"] = "@loop.inner",
				["ac"] = "@conditional.outer",
				["ic"] = "@conditional.inner",
			},
			selection_modes = {},
		},
		move = {
			enable = true,
			disable = { "tex", "latex" },
			set_jumps = true,
			goto_next_start = {
				["]m"] = "@function.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
			},
		},
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
		commentary_integration = {
			Commentary = false,
			CommentaryLine = false,
			ChangeCommentary = false,
			CommentaryUndo = false,
		},
	},
})
