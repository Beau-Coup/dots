require("conform").setup({
	formatters = {
		superhtml = {
			inherit = false,
			command = "superhtml",
			stdin = true,
			args = { "fmt", "--stdin" },
		},
		ziggy = {
			inherit = false,
			command = "ziggy",
			stdin = true,
			args = { "fmt", "--stdin" },
		},
		ziggy_schema = {
			inherit = false,
			command = "ziggy",
			stdin = true,
			args = { "fmt", "--stdin-schema" },
		},
	},

	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		rust = { "rustfmt", lsp_format = "fallback" },
		-- Conform will run the first available formatter
		javascript = { "prettierd", "prettier", stop_after_first = true },
		zig = { "zigfmt" },
		shtml = { "superhtml" },
		ziggy = { "ziggy" },
		ziggy_schema = { "ziggy_schema" },
		c = { "clang-format" },
		cs = { "clang-format" },
		tex = { "autocorrect" },
		bibtex = { "bibtex-tidy" },
	},
})

require("conform").setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})
