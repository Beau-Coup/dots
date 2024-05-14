local lspconfig = require("lspconfig")

local lspattach = function(client, bufnr)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
	vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr })
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
	vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
	vim.keymap.set({ "n" }, "<leader>K", vim.lsp.buf.signature_help, { buffer = bufnr })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
	vim.keymap.set("n", "<leader>f", vim.lsp.buf.formatting, { buffer = bufnr })
	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

	if client.server_capabilities.declarationProvider then
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
	else
		vim.keymap.set("n", "gD", vim.lsp.buf.definition, { buffer = bufnr })
	end
end

local default_config = {
	on_attach = lspattach,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
}

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	update_in_insert = false,
	underline = true,
	severity_sort = false,
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

vim.api.nvim_create_autocmd("CursorHold", {
	buffer = bufnr,
	callback = function()
		local opts = {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "rounded",
			source = "always",
			prefix = " ",
			scope = "cursor",
		}
		vim.diagnostic.open_float(nil, opts)
	end,
})

-- setup language servers here
lspconfig.tsserver.setup(default_config)
lspconfig.pyright.setup(default_config)
lspconfig.lua_ls.setup(default_config)
lspconfig.texlab.setup({ default_config, filetypes = { "markdown", "tex" } })
lspconfig.clangd.setup(default_config)
lspconfig.tailwindcss.setup(default_config)
lspconfig.zls.setup(default_config)

lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

vim.g.rustaceanvim = {
	server = {
		on_attach = lspattach,
	},
}

require("clangd_extensions").setup({
	server = default_config,
})
