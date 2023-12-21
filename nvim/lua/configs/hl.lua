local colors = require("catppuccin.palettes").get_palette("macchiato")

local hlgroups = {
	TelescopePromptPrefix = {
		fg = colors.blue,
		bg = colors.mantle,
	},
	TelescopeNormal = { bg = colors.crust },
	TelescopePromptTitle = {
		fg = colors.crust,
		bg = colors.blue,
	},
	TelescopePreviewTitle = {
		fg = colors.crust,
		bg = colors.green,
	},

	TelescopeSelection = {
		fg = colors.text,
		bg = colors.mantle,
	},

	TelescopeBorder = {
		fg = colors.crust,
		bg = colors.crust,
	},

	TelescopePromptBorder = {
		fg = colors.mantle,
		bg = colors.mantle,
	},
	TelescopePromptNormal = {
		fg = colors.lavender,
		bg = colors.mantle,
	},
	TelescopeResultsTitle = {
		fg = colors.crust,
		bg = colors.crust,
	},

	-- Now for diagnostics windows
	FloatBorder = {
		fg = colors.overlay0,
		bg = colors.gray,
	},
}

for key, value in pairs(hlgroups) do
	vim.api.nvim_set_hl(0, tostring(key), value)
end
