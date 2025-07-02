vim.g.mapleader = " "

vim.keymap.set({ "n", "v" }, "<c-d>", "<c-d>zz")
vim.keymap.set({ "n", "v" }, "<c-u>", "<c-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Some sane keymaps
vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("v", "jk", "<ESC>")

local keys = "dvo"
local function switch_map()
	if keys == "dvo" then
		vim.o.langmap = ""
		keys = "qwe"
	else
		vim.o.langmap = "dh,hj,tk,nl,jd"
		keys = "dvo"
	end
end
vim.keymap.set("n", "<leader>lrm", switch_map)
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
local gitleader = "<leader>g"
vim.keymap.set("v", gitleader .. "hs", function()
	gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "stage current selection" })
vim.keymap.set("v", gitleader .. "hr", function()
	gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "reset selected hunk" })
vim.keymap.set("n", gitleader .. "hS", gs.stage_buffer, { desc = "stage buffer" })
vim.keymap.set("n", gitleader .. "hu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
vim.keymap.set("n", gitleader .. "hR", gs.reset_buffer, { desc = "reset buffer" })
vim.keymap.set("n", gitleader .. "hp", gs.preview_hunk, { desc = "preview hunk" })
vim.keymap.set("n", gitleader .. "b", gs.blame_line, { desc = "blame line" })
vim.keymap.set("n", gitleader .. "B", function()
	gs.blame_line({ full = true })
end, { desc = "blame line full" })
vim.keymap.set("n", gitleader .. "tb", gs.toggle_current_line_blame, { desc = "toggle current line blame" })
vim.keymap.set("n", gitleader .. "hd", gs.diffthis, { desc = "diff current file" })
vim.keymap.set("n", gitleader .. "hD", function()
	gs.diffthis("~")
end, { desc = "diff directory" })
vim.keymap.set("n", gitleader .. "td", gs.toggle_deleted, { desc = "toggle deleted" })

-- Text object
vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "hunk text object" })

-- Neorg mappings
vim.keymap.set("n", "<localleader>nw", ":Neorg workspace ", {})
vim.keymap.set("n", "<localleader>nn", "<Plug>(neorg.dirman.new-note)", {})

vim.keymap.set("n", "<localleader>]", "<Plug>(neorg.presenter.next-page)", { desc = "next slide" })
vim.keymap.set("n", "<localleader>[", "<Plug>(neorg.presenter.previous-page)", { desc = "previous slide" })
vim.keymap.set("n", "<localleader>q", "<Plug>(neorg.presenter.close)", { desc = "close slides" })
vim.keymap.set("n", "<localleader>ps", ":Neorg presenter start<CR>", { desc = "Start presentation" })
vim.keymap.set(
	"n",
	"<localleader>cm",
	"<Plug>(neorg.looking-glass.magnify-code-block)",
	{ desc = "magnify code block" }
)
vim.keymap.set("n", "<localleader>q", "<Plug>()", { desc = "close slides" })

-- Zen mode
vim.keymap.set("n", "<leader>z", ":ZenMode<CR>", { desc = "Toggle zen mode" })

vim.api.nvim_set_keymap("x", "<leader>zz", [[:<C-u>lua CenterVisualSelection()<CR>]], { noremap = true, silent = true })
function CenterVisualSelection()
	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")
	local center_line = math.floor((start_line + end_line) / 2)
	vim.cmd(tostring(center_line))
	vim.cmd(":normal! zz<CR>")
end
