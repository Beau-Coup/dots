vim.g.mapleader = " "

vim.keymap.set({ "n", "v" }, "<c-d>", "<c-d>zz")
vim.keymap.set({ "n", "v" }, "<c-u>", "<c-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Some sane keymaps
vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("v", "jk", "<ESC>")

vim.keymap.set("n", "<leader>fs", ":w<CR>")
vim.keymap.set("n", "<leader>qs", ":wq<CR>")
vim.keymap.set("n", "<leader>qq", ":qa<CR>")
vim.keymap.set("n", "<leader>bd", ":q<CR>")

-- Delete section and put in void buffer, then paste reg contents
vim.keymap.set("x", "<leader>p", '"_dP')

-- yank
vim.keymap.set({ "v", "n" }, "<leader>y", '"+y')

-- Window motiongs
vim.keymap.set("n", "<leader>w", "<C-w>")
vim.keymap.set("n", "<leader>op", ":NvimTreeToggle<CR>")

-- Delete all buffers but current
vim.keymap.set("n", "<leader>0", ":%bd|e#|bd#<CR>")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, { desc = "[D]ocument [S]ymbols" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })
vim.keymap.set(
	"n",
	"<leader>ss",
	require("telescope.builtin").lsp_dynamic_workspace_symbols,
	{ desc = "[W]orkspace [S]ymbols" }
)

-- Set keymaps for debugging
local dap = require("dap")
vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F10>", dap.step_over)
vim.keymap.set("n", "<F11>", dap.step_into)
vim.keymap.set("n", "<F12>", dap.step_out)
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>B", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)
vim.keymap.set("n", "<leader>lp", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Log breakpoint message: "))
end)
vim.keymap.set("n", "<leader>dr", dap.repl.open)

vim.keymap.set("n", "<Leader>dl", function()
	require("dap").run_last()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
	require("dap.ui.widgets").hover()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
	require("dap.ui.widgets").preview()
end)
vim.keymap.set("n", "<Leader>df", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end)
-- vim.keymap.set("n", "<Leader>ds", function()
-- 	local widgets = require("dap.ui.widgets")
-- 	widgets.centered_float(widgets.scopes)
-- end)

local gs = require("gitsigns")
-- Navigation
vim.keymap.set("n", "]c", function()
	if vim.wo.diff then
		return "]c"
	end
	vim.schedule(function()
		gs.next_hunk()
	end)
	return "<Ignore>"
end, { expr = true })

vim.keymap.set("n", "[c", function()
	if vim.wo.diff then
		return "[c"
	end
	vim.schedule(function()
		gs.prev_hunk()
	end)
	return "<Ignore>"
end, { expr = true })

-- Actions
-- vim.keymap.set("n", "<leader>hs", gs.stage_hunk)
-- vim.keymap.set("n", "<leader>hr", gs.reset_hunk)
vim.keymap.set("v", "<leader>hs", function()
	gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end)
vim.keymap.set("v", "<leader>hr", function()
	gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end)
vim.keymap.set("n", "<leader>hS", gs.stage_buffer)
vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk)
vim.keymap.set("n", "<leader>hR", gs.reset_buffer)
vim.keymap.set("n", "<leader>hp", gs.preview_hunk)
vim.keymap.set("n", "<leader>gb", function()
	gs.blame_line()
end)
vim.keymap.set("n", "<leader>gB", function()
	gs.blame_line({ full = true })
end)
vim.keymap.set("n", "<leader>tb", gs.toggle_current_line_blame)
vim.keymap.set("n", "<leader>hd", gs.diffthis)
vim.keymap.set("n", "<leader>hD", function()
	gs.diffthis("~")
end)
vim.keymap.set("n", "<leader>td", gs.toggle_deleted)

-- Text object
vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")

vim.keymap.set("n", "<localleader>nn", "<Plug>(neorg.dirman.new-note)", {})
