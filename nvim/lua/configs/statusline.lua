local colors = require("catppuccin.palettes").get_palette("macchiato")

local merge_tb = vim.tbl_deep_extend

-- default values from the colors palette
local statusline_bg = colors.crust
local light_grey = colors.mantle

local Lsp_highlights = {
	St_lspError = {
		fg = colors.red,
		bg = statusline_bg,
	},

	St_lspWarning = {
		fg = colors.yellow,
		bg = statusline_bg,
	},

	St_LspHints = {
		fg = colors.purple,
		bg = statusline_bg,
	},

	St_LspInfo = {
		fg = colors.green,
		bg = statusline_bg,
	},
}

local Color = {}

Color.default = {
	StatusLine = {
		bg = statusline_bg,
	},

	St_gitIcons = {
		fg = colors.text,
		bg = statusline_bg,
		bold = true,
	},

	St_LspStatus = {
		fg = colors.blue,
		bg = statusline_bg,
	},

	St_LspProgress = {
		fg = colors.green,
		bg = statusline_bg,
	},

	St_LspStatus_Icon = {
		fg = colors.base,
		bg = colors.blue,
	},

	St_EmptySpace = {
		fg = colors.crust,
		bg = colors.lavender,
	},

	St_EmptySpace2 = {
		fg = colors.mantle,
		bg = statusline_bg,
	},

	St_file_info = {
		bg = colors.lavender,
		fg = colors.mantle,
	},

	St_file_sep = {
		bg = colors.crust,
		fg = colors.lavender,
	},

	St_cwd_icon = {
		fg = colors.crust,
		bg = colors.red,
	},

	St_cwd_text = {
		fg = colors.text,
		bg = colors.mantle,
	},

	St_cwd_sep = {
		fg = colors.red,
		bg = statusline_bg,
	},

	St_pos_sep = {
		fg = colors.green,
		bg = colors.mantle,
	},

	St_pos_icon = {
		fg = colors.crust,
		bg = colors.green,
	},

	St_pos_text = {
		fg = colors.green,
		bg = colors.mantle,
	},
}

-- add common lsp highlights
Color.default = merge_tb("force", Color.default, Lsp_highlights)

local function genModes_hl(modename, col)
	Color.default["St_" .. modename .. "Mode"] = { fg = colors.base, bg = colors[col], bold = true }
	Color.default["St_" .. modename .. "ModeSep"] = { fg = colors[col], bg = colors.crust }
end

local function lol(c)
	for key, value in pairs(c) do
		vim.api.nvim_set_hl(0, tostring(key), value)
	end
end

-- add mode highlights
genModes_hl("Normal", "blue")

genModes_hl("Visual", "sky")
genModes_hl("Insert", "lavender")
genModes_hl("Terminal", "green")
genModes_hl("NTerminal", "yellow")
genModes_hl("Replace", "peach")
genModes_hl("Confirm", "teal")
genModes_hl("Command", "green")
genModes_hl("Select", "blue")

lol(Color.default)
Color = Color.default

local fn = vim.fn
local config = {
	theme = "catppuccin", -- default/vscode/vscode_colored/minimal
	-- round and block will work for minimal theme only
	separator_style = "default",
	overriden_modules = nil,
}

local sep_style = config.separator_style

local default_sep_icons = {
	default = { left = "", right = " " },
	round = { left = "", right = "" },
	block = { left = "█", right = "█" },
	arrow = { left = "", right = "" },
}

local separators = (type(sep_style) == "table" and sep_style) or default_sep_icons[sep_style]

local sep_l = separators["left"]
local sep_r = separators["right"]

local M = {}

M.modes = {
	["n"] = { "NORMAL", "St_NormalMode" },
	["no"] = { "NORMAL (no)", "St_NormalMode" },
	["nov"] = { "NORMAL (nov)", "St_NormalMode" },
	["noV"] = { "NORMAL (noV)", "St_NormalMode" },
	["noCTRL-V"] = { "NORMAL", "St_NormalMode" },
	["niI"] = { "NORMAL i", "St_NormalMode" },
	["niR"] = { "NORMAL r", "St_NormalMode" },
	["niV"] = { "NORMAL v", "St_NormalMode" },
	["nt"] = { "NTERMINAL", "St_NTerminalMode" },
	["ntT"] = { "NTERMINAL (ntT)", "St_NTerminalMode" },

	["v"] = { "VISUAL", "St_VisualMode" },
	["vs"] = { "V-CHAR (Ctrl O)", "St_VisualMode" },
	["V"] = { "V-LINE", "St_VisualMode" },
	["Vs"] = { "V-LINE", "St_VisualMode" },
	[""] = { "V-BLOCK", "St_VisualMode" },

	["i"] = { "INSERT", "St_InsertMode" },
	["ic"] = { "INSERT (completion)", "St_InsertMode" },
	["ix"] = { "INSERT completion", "St_InsertMode" },

	["t"] = { "TERMINAL", "St_TerminalMode" },

	["R"] = { "REPLACE", "St_ReplaceMode" },
	["Rc"] = { "REPLACE (Rc)", "St_ReplaceMode" },
	["Rx"] = { "REPLACEa (Rx)", "St_ReplaceMode" },
	["Rv"] = { "V-REPLACE", "St_ReplaceMode" },
	["Rvc"] = { "V-REPLACE (Rvc)", "St_ReplaceMode" },
	["Rvx"] = { "V-REPLACE (Rvx)", "St_ReplaceMode" },

	["s"] = { "SELECT", "St_SelectMode" },
	["S"] = { "S-LINE", "St_SelectMode" },
	[""] = { "S-BLOCK", "St_SelectMode" },
	["c"] = { "COMMAND", "St_CommandMode" },
	["cv"] = { "COMMAND", "St_CommandMode" },
	["ce"] = { "COMMAND", "St_CommandMode" },
	["r"] = { "PROMPT", "St_ConfirmMode" },
	["rm"] = { "MORE", "St_ConfirmMode" },
	["r?"] = { "CONFIRM", "St_ConfirmMode" },
	["x"] = { "CONFIRM", "St_ConfirmMode" },
	["!"] = { "SHELL", "St_TerminalMode" },
}

M.mode = function()
	local m = vim.api.nvim_get_mode().mode
	local current_mode = "%#" .. M.modes[m][2] .. "#" .. "  " .. M.modes[m][1]
	local mode_sep1 = "%#" .. M.modes[m][2] .. "Sep" .. "#" .. sep_r

	return current_mode .. mode_sep1 .. "%#ST_EmptySpace#" .. sep_r
end

M.fileInfo = function()
	local icon = " 󰈚 "
	local filename = (fn.expand("%") == "" and "Empty ") or fn.expand("%:t")

	if filename ~= "Empty " then
		local devicons_present, devicons = pcall(require, "nvim-web-devicons")

		if devicons_present then
			local ft_icon = devicons.get_icon(filename)
			icon = (ft_icon ~= nil and " " .. ft_icon) or ""
		end

		filename = " " .. filename .. " "
	end

	return "%#St_file_info#" .. "%n" .. icon .. filename .. "%#St_file_sep#" .. sep_r
end

M.git = function()
	if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
		return ""
	end

	local git_status = vim.b.gitsigns_status_dict

	local added = (git_status.added and git_status.added ~= 0) and ("  " .. git_status.added) or ""
	local changed = (git_status.changed and git_status.changed ~= 0) and ("  " .. git_status.changed) or ""
	local removed = (git_status.removed and git_status.removed ~= 0) and ("  " .. git_status.removed) or ""
	local branch_name = "  " .. git_status.head

	return "%#St_gitIcons#" .. branch_name .. added .. changed .. removed
end

-- LSP STUFF
M.LSP_progress = function()
	if not rawget(vim, "lsp") or vim.lsp.status then
		return ""
	end

	local Lsp = vim.lsp.util.get_progress_messages()[1]

	if vim.o.columns < 120 or not Lsp then
		return ""
	end

	if Lsp.done then
		vim.defer_fn(function()
			vim.cmd.redrawstatus()
		end, 1000)
	end

	local msg = Lsp.message or ""
	local percentage = Lsp.percentage or 0
	local title = Lsp.title or ""
	local spinners = { "", "󰪞", "󰪟", "󰪠", "󰪢", "󰪣", "󰪤", "󰪥" }
	local ms = vim.loop.hrtime() / 1000000
	local frame = math.floor(ms / 120) % #spinners
	local content = string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)

	if config.lsprogress_len then
		content = string.sub(content, 1, config.lsprogress_len)
	end

	return ("%#St_LspProgress#" .. content) or ""
end

M.LSP_Diagnostics = function()
	if not rawget(vim, "lsp") then
		return ""
	end

	local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
	local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
	local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

	errors = (errors and errors > 0) and ("%#St_lspError#" .. " " .. errors .. " ") or ""
	warnings = (warnings and warnings > 0) and ("%#St_lspWarning#" .. "  " .. warnings .. " ") or ""
	hints = (hints and hints > 0) and ("%#St_lspHints#" .. "󰛩 " .. hints .. " ") or ""
	info = (info and info > 0) and ("%#St_lspInfo#" .. "󰋼 " .. info .. " ") or ""

	return errors .. warnings .. hints .. info
end

M.LSP_status = function()
	if rawget(vim, "lsp") then
		for _, client in ipairs(vim.lsp.get_active_clients()) do
			if client.attached_buffers[vim.api.nvim_get_current_buf()] and client.name ~= "null-ls" then
				return (vim.o.columns > 100 and "%#St_LspStatus#" .. "   LSP ~ " .. client.name .. " ")
					or "   LSP "
			end
		end
	end
end

M.cwd = function()
	local dir_icon = "%#St_cwd_icon#" .. "󰉋 "
	local dir_name = "%#St_cwd_text#" .. " " .. fn.fnamemodify(fn.getcwd(), ":t") .. " "
	return (vim.o.columns > 85 and ("%#St_cwd_sep#" .. sep_l .. dir_icon .. dir_name)) or ""
end

M.cursor_position = function()
	local left_sep = "%#St_pos_sep#" .. sep_l .. "%#St_pos_icon#" .. " "

	local current_line = fn.line(".")
	local total_line = fn.line("$")
	local text = math.modf((current_line / total_line) * 100) .. tostring("%%")
	text = string.format("%4s", text)

	text = (current_line == 1 and "Top") or text
	text = (current_line == total_line and "Bot") or text

	return left_sep .. "%#St_pos_text#" .. " " .. text .. " "
end

M.run = function()
	local modules = {
		M.mode(),
		M.fileInfo(),
		M.git(),

		"%=",
		M.LSP_progress(),
		"%=",

		M.LSP_Diagnostics(),
		M.LSP_status() or "",
		M.cwd(),
		M.cursor_position(),
	}

	if config.overriden_modules then
		config.overriden_modules(modules)
	end

	return table.concat(modules)
end

return M
