-- Some sane settings
vim.o.smartcase = true
vim.o.showmode = false
vim.bo.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.stdpath("config") .. "/undodir"
vim.o.undofile = true
vim.o.incsearch = true
vim.o.hidden = true
vim.o.completeopt = "menuone,noinsert,noselect"
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.o.updatetime = 700

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"
vim.wo.wrap = false

-- Use plugins :)
require("plugins")

require("configs.keymap")

require("configs.hop")
-- LanguageTool
vim.g.languagetool_jar = "$HOME/Downloads/LanguageTool-5.2/languagetool-commandline.jar"

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

pcall(require("telescope").load_extension, "fzf")

-- Set the theme to wal
-- require('configs.colorscheme')
local hour = tonumber(os.date("%H"))
if hour < 16 and hour >= 6 then
	vim.cmd.colorscheme("catppuccin-latte")
else
	vim.cmd.colorscheme("catppuccin-macchiato")
end

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
require("configs.tree")

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
