-- Some sane settings
vim.g.mapleader = " "
vim.g.maplocalleader = ","
local opt = vim.opt

opt.autowrite = true -- Enable auto write
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 1 -- Hide * markup for bold and italic
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = false -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
-- opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.incsearch = true
opt.laststatus = 3
opt.list = true -- Show some invisible characters (tabs...
opt.listchars:append({ space = "·" })
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 8 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 4 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true })
opt.showmode = true -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = false -- Insert indents automatically
opt.spelllang = { "en_us" }
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
vim.opt.statusline = "%!v:lua.require('configs.statusline').run()"
opt.tabstop = 4 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 1000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.textwidth = 0
opt.wrapmargin = 0
opt.linebreak = true
opt.wrap = true -- Disable line wrap

-- local augroup = vim.api.nvim_create_augroup("vimRCAugroup", {})
--
-- vim.api.nvim_clear_autocmds({ group = augroup })
-- vim.api.nvim_create_autocmd("WinNew", {
-- 	group = augroup,
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.cmd([[wincmd L]])
-- 	end,
-- })
