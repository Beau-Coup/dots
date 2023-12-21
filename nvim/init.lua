-- Set the theme to wal
-- require('configs.colorscheme')
require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    transparent_background = true, -- disables setting the background color.
})
vim.cmd.colorscheme("catppuccin")

require("configs.opts")
require("configs.filetype")

-- Use plugins :)
require("plugins")

require("configs.telescope")
require("configs.hl")

require("configs.keymap")

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
require("configs.null-ls")

-- LSP stuff
require("configs.lsp")

-- Set up nvim-cmp.
require("configs.cmp")

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
require("mason").setup()

--dap
require("configs.dap")

-- Vimtex stuff
vim.g.vimtex_view_general_viewer = "zathura"
vim.g.vimtex_view_zathura_options = "-reuse-instance"
vim.g.tex_flavor = "latex"
