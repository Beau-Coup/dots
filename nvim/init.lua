-- Set the theme to wal
-- require('configs.colorscheme')
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Use plugins :)
require("plugins")

require("catppuccin").setup({
	flavour = "mocha", -- latte, frappe, macchiato, mocha
	transparent_background = true, -- disables setting the background color.
})
vim.cmd.colorscheme("catppuccin")

require("configs.opts")
require("configs.filetype")

require("configs.telescope")
require("configs.hl")

require("configs.keymap")
-- require("configs.harpoon")

require("configs.hop")

require("configs.snippets")

-- LanguageTool
vim.g.languagetool_jar = "$HOME/Downloads/LanguageTool-5.2/languagetool-commandline.jar"

-- Status line
vim.opt.statusline = "%!v:lua.require('configs.statusline').run()"

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

pcall(require("telescope").load_extension, "fzf")

-- Configure treesitter
require("configs.treesitter")

-- rounded windows

-- Formatter
-- require("configs.formatter")
-- require("configs.null-ls")
require("configs.conform")

-- LSP stuff
require("configs.lsp")

-- Set up nvim-cmp.
require("configs.cmp")

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
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- setup neotree
-- require("configs.tree")

-- Toggleterm
require("configs.toggleterm")

-- Lazygit in Toggleterm
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
function _LG_TOGGLE()
	lazygit:toggle()
end

vim.keymap.set("n", "<leader>gg", ":lua _LG_TOGGLE()<CR>")

-- Mason
-- require("mason").setup()

-- Vimtex stuff
vim.g.vimtex_view_method = "skim"
vim.g.tex_flavor = "latex"
vim.g.vimtex_quickfix_open_on_warning = 0
vim.g.vimtex_view_skim_sync = 1
vim.g.vimtex_view_skim_activate = 1

--dap
require("configs.dap")
require("configs.copilot")
