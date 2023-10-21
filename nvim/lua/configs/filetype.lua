vim.g.do_filetype_lua = true

vim.g.vim_markdown_math = true
vim.g.vim_markdown_folding_disabled = 1
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.md",
	callback = function()
		vim.cmd("call vimtex#init()")
	end,
	group = vim.api.nvim_create_augroup("setVimtexMarkdownKeybinds", {}),
	desc = "Set vimtex keybinds for Markdown",
})
