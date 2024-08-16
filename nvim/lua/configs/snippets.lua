local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local ai = require("luasnip.nodes.absolute_indexer")

local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")
local key = require("luasnip.nodes.key_indexer").new_key

local notify = require("notify")
-- require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })

-- If you're reading this file for the first time, best skip to around line 190
-- where the actual snippet-definitions start.

-- Every unspecified option will be set to the default.
ls.setup({
	history = true,
	-- Update more often, :h events for more info.
	update_events = "TextChanged,TextChangedI",
	-- Snippets aren't automatically removed if their text is deleted.
	-- `delete_check_events` determines on which events (:h events) a check for
	-- deleted snippets is performed.
	-- This can be especially useful when `history` is enabled.
	delete_check_events = "TextChanged",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "<-", "Error" } },
			},
		},
	},
	-- treesitter-hl has 100, use something higher (default is 200).
	ext_base_prio = 300,
	-- minimal increase in priority.
	ext_prio_increase = 1,
	enable_autosnippets = true,
	-- mapping for cutting selected text so it's usable as SELECT_DEDENT,
	-- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
	-- store_selection_keys = "<Tab>",
	-- luasnip uses this function to get the currently active filetype. This
	-- is the (rather uninteresting) default, but it's possible to use
	-- eg. treesitter for getting the current filetype by setting ft_func to
	-- require("luasnip.extras.filetype_functions").from_cursor (requires
	-- `nvim-treesitter/nvim-treesitter`). This allows correctly resolving
	-- the current filetype in eg. a markdown-code block or `vim.cmd()`.
	ft_func = function()
		return vim.split(vim.bo.filetype, ".", true)
	end,
})

-- Snippets for everything
ls.add_snippets("all", {
	s({ trig = "date" }, {
		f(function()
			return os.date("%Y-%m-%d")
		end),
	}),
}, { key = "all-snips" })
-- 'recursive' dynamic snippet. Expands to some text followed by itself.
local rec_ls
rec_ls = function()
	return sn(
		nil,
		c(1, {
			-- Order is important, sn(...) first would cause infinite loop of expansion.
			t(""),
			sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
		})
	)
end

local tex = {}
tex.in_mathzone = function()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
tex.in_text = function()
	return not tex.in_mathzone()
end

-- Magical table shit
local table_node = function(args)
	local tabs = {}
	local count
	local cols = args[1][1]:gsub("%s", ""):gsub("|", "")
	count = cols:len()
	for j = 1, count do
		local iNode = i(j)
		table.insert(tabs, iNode)
		if j ~= count then
			table.insert(tabs, t(" & "))
		end
	end
	return sn(nil, tabs)
end

local rec_table
rec_table = function()
	return sn(nil, {
		c(1, {
			t({ "" }),
			sn(nil, {
				t({ "\\\\", "" }),
				d(1, table_node, { ai[1] }),
				d(2, rec_table, { ai[1] }),
			}),
		}),
	})
end

-- Functions for alignment environments
-- local align_node = function(args)
--     return sn(nil, {i(1), t("&"), i(2)})

-- integral functions
-- generate \int_{<>}^{<>}
local int1 = function(args, snip)
	local vars = tonumber(snip.captures[1])
	local nodes = {}
	for j = 1, vars do
		table.insert(nodes, t("\\int_{"))
		table.insert(nodes, r(2 * j - 1, "lb" .. tostring(j), i(1))) -- thanks L3MON4D3 for finding the index issue
		table.insert(nodes, t("}^{"))
		table.insert(nodes, r(2 * j, "ub" .. tostring(j), i(1))) -- please remember to count and don't be like me
		table.insert(nodes, t("} "))
	end
	return sn(nil, nodes)
end

-- generate \dd <>
local int2 = function(args, snip)
	local vars = tonumber(snip.captures[1])
	local nodes = {}
	for j = 1, vars do
		table.insert(nodes, t(" \\dd "))
		table.insert(nodes, r(j, "var" .. tostring(j), i(1)))
	end
	return sn(nil, nodes)
end

local mat = function(args, snip)
	local rows = tonumber(snip.captures[2])
	local cols = tonumber(snip.captures[3])
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t({ " \\\\", "" }))
	end
	-- fix last node.
	nodes[#nodes] = t(" \\\\")
	return sn(nil, nodes)
end

-- Define suffix modifiers
-- k: the trigger, v: sub
local suffs = {
	hat = "hat",
	til = "tilde",
	ba = "overline",
	dd = "ddot",
	["do"] = "dot",
}

local suffixes = {}
for k, _ in pairs(suffs) do
	suffixes[#suffixes + 1] = k
end
local suffix_match = table.concat(suffixes, "|")

tex.snippets = {
	s(
		{
			trig = "(%d)int",
			show_condition = tex.in_mathzone,
			name = "multi integrals",
			dscr = "please work",
			regTrig = true,
			hidden = false,
		},
		fmt([[ <> <> <> <> ]], {
			c(1, {
				fmta([[\<><>nt_{<>}]], {
					c(1, { t(""), t("o") }),
					f(function(_, parent, snip)
						local inum = tonumber(parent.parent.captures[1]) -- this guy's lineage looking like a research lab's
						return string.rep("i", inum)
					end),
					i(2),
				}),
				d(nil, int1),
			}),
			i(2),
			d(3, int2),
			i(0),
		}, { delimiters = "<>" })
	),
	s("tab", {
		t("\\begin{tabular}{"),
		i(1),
		t({ "}", "" }),
		d(2, table_node, { 1 }, {}),
		d(3, rec_table, { 1 }),
		t({ "", "\\end{tabular}" }),
	}),
	s({ trig = "ls", show_condition = tex.in_mathzone }, {
		t({ "\\begin{itemize}", "\t\\item " }),
		i(1),
		d(2, rec_ls, {}),
		t({ "", "\\end{itemize}" }),
	}),
	s({ trig = "boiler", show_condition = tex.in_text }, {
		t({
			"\\documentclass[12pt]{article}",
			"\\usepackage[utf8]{inputenc}",
			"\\usepackage[margin=1.5in]{geometry}",
			"\\usepackage{physics}",
			"\\usepackage{amssymb}",
			"\\usepackage{amsmath}",
			"\\begin{document}",
			"Hello",
			"\\end{document}",
		}),
	}),
	s({ trig = "beg", show_condition = tex.in_text }, {
		t({ "\\begin{" }),
		i(1),
		t({ "}", "" }),
		i(2),
		f(function(args, _, _)
			return { "\t", "\\end{" .. args[1][1] .. "}" }
		end, { 1 }),
		i(0),
	}),
	s(
		{ trig = "([%\\]?[A-Za-z]+)(%d+)", regTrig = true, name = "auto subscript", hidden = true },
		fmta([[<><>_{<>}<>]], {
			f(function(_, _)
				return tex.in_mathzone() and "" or "$"
			end),
			f(function(_, snip)
				return snip.captures[1] -- Identify if in math zone and add inline math delims
			end),
			f(function(_, snip)
				return snip.captures[2]
			end),
			f(function(_, _)
				return tex.in_mathzone() and "" or "$"
			end),
		})
	),
	s({ trig = "uu", wordTrig = false, snippetType = "autosnippet", hidden = true }, fmta([[_{<>}]], { i(1) })),
	s({ trig = "ii", wordTrig = false, snippetType = "autosnippet", hidden = true }, fmta([[^{<>}]], { i(1) })),
	s(
		{ trig = "tp", snippetType = "autosnippet", wordTrig = false },
		fmta("^{\\mathsf{T}}", {}),
		{ condition = tex.in_mathzone } -- `condition` option passed in the snippet `opts` table
	),
	s(
		{ trig = "rr", snippetType = "autosnippet", wordTrig = true },
		fmta("\\mathbb{R}^{<>}", { i(1) }),
		{ condition = tex.in_mathzone } -- `condition` option passed in the snippet `opts` table
	),
	s(
		{ trig = "irr", snippetType = "autosnippet", wordTrig = true },
		fmta("\\in \\mathbb{R}^{<>}", { i(1) }),
		{ condition = tex.in_mathzone } -- `condition` option passed in the snippet `opts` table
	),
	s(
		{ trig = "ff", snippetType = "autosnippet" },
		fmta("\\frac{<>}{<>}", {
			i(1),
			i(2),
		}),
		{ condition = tex.in_mathzone } -- `condition` option passed in the snippet `opts` table
	),
	s(
		{ trig = "ee", snippetType = "autosnippet" },
		fmta("e^{<>}", {
			i(1),
		}),
		{ condition = tex.in_mathzone } -- `condition` option passed in the snippet `opts` table
	),
	s({ trig = "nn", snippetType = "autosnippet" }, {
		t({ "\\begin{equation}", "\t" }),
		i(1),
		t({ "", "\\end{equation}", "" }),
		i(0),
	}),
	s({ trig = "dm", show_condition = tex.in_mathzone }, {
		t({ "\\mqty(\\dmat[0]{" }),
		i(1),
		t({ "})" }),
		i(0),
	}),
	s(
		{
			trig = "([bBpvV])(%d+)x(%d+)",
			regTrig = true,
			name = "matrix",
			dscr = "arbitrary matrix gen snippet",
			hidden = true,
		},
		fmta(
			[[
    \begin{<>}
    <>
    \end{<>}]],
			{
				f(function(_, snip)
					return snip.captures[1] .. "matrix" -- captures matrix type
				end),
				d(1, mat),
				f(function(_, snip)
					return snip.captures[1] .. "matrix" -- i think i could probably use a repeat node but whatever
				end),
			}
		)
	),
	s({ trig = "mt", show_condition = tex.in_text }, {
		t({ "\\[", "\t" }),
		i(1),
		t({ "", "\\]" }),
		i(0),
	}),
	s({ trig = "mmica" }, {
		fmta([[math <> math]], { i(1) }),
	}),
	s(
		{ trig = "math(.*)math", regTrig = true, dscr = "Evaluate mathematica", hidden = true },
		fmta([[<>]], {
			f(function(_, snip)
				local code = "'ToString[" .. snip.captures[1] .. ", TeXForm]'"
				local openPop = io.popen("wolframscript -code " .. code, "r")
				if openPop ~= nil then
					local out = openPop:read("*a")
					t = {}
					for str in string.gmatch(out, "([^\n]+)") do
						t[#t + 1] = str
					end
					openPop:close()
					if t then
						return t
					else
						require("notify")("Failed to parse snippet:" .. out, "error", { title = "Mathematica" })
					end
				end
				return "math" .. snip.captures[1] .. "math"
			end),
		})
	),
	s(
		{ trig = "(%b())/", regTrig = true, snippetType = "autosnippet", dscr = "() fraction", hidden = true },
		fmta([[\frac{<>}{<>}]], { f(function(_, snip)
			return snip.captures[1]:sub(2, -2)
		end), i(1) })
	),
	s(
		{ trig = "(%S+)/", regTrig = true, snippetType = "autosnippet", dscr = "fraction", hidden = true },
		fmta([[\frac{<>}{<>}]], { f(function(_, snip)
			return snip.captures[1]
		end), i(1) })
	),
	s(
		{ trig = "align", snippetType = "autosnippet", hidden = false },
		fmta(
			[[\begin{<>}
    <>
\end{<>}]],
			{
				c(1, { t("align"), t("aligned") }),
				-- recursive node, maybe??
				i(2),
				f(function(args, _, _)
					return args[1][1]
				end, { 1 }),
			}
		)
	),
	s(
		{ trig = "alphl", snippetType = "autosnippet", wordTrig = true },
		fmta(
			[[\begin{list}{(\alph{l2})}{\usecounter{l2}}
    <> 
\end{list}]],
			{ i(1) }
		)
	),
	s(
		{ trig = "arl", snippetType = "autosnippet", wordTrig = true },
		fmta(
			[[\begin{list}{\bf \arabic{l1}}{\usecounter{l1}}
<> 
\end{list}]],
			{ i(1) }
		)
	),
	s({ trig = " mk", regTrig = true, show_condition = tex.in_text }, {
		t("$"),
		i(1),
		t("$"),
		i(0),
	}),
	s({ trig = "v", show_condition = tex.in_mathzone }, {
		t("\\vb{"),
		i(1),
		t("}"),
		i(0),
	}),
	s({ trig = "bb", show_condition = tex.in_mathzone }, {
		t("\\mathbb{"),
		i(1),
		t("}"),
		i(0),
	}),
	s(
		{ trig = "fun", show_condition = tex.in_text },
		fmt([[${}: {} \to {}$]], {
			i(1, "\\varphi"),
			c(2, {
				i(nil),
				sn(nil, { t("mathbb{"), i(1), t("}") }),
				sn(nil, { t("mathcal{"), i(1), t("}") }),
			}),
			c(3, {
				i(nil),
				sn(nil, { t("\\mathbb{"), i(1), t("}") }),
				sn(nil, { t("\\mathcal{"), i(1), t("}") }),
			}),
		})
	),
	s(
		{ trig = "ip", show_condition = tex.in_mathzone },
		fmt([[\langle {}, {} \rangle]], {
			i(1, "u"),
			i(2, "v"),
		})
	),
	s(
		{ trig = "w", show_condition = tex.in_mathzone, dscr = "Wedge operator", dosctring = "\\wedge" },
		{ t("\\wedge") }
	),
	s(
		{
			trig = [[(\S*)(?:\.,|,\.)]],
			trigEngine = "ecma",
			snippetType = "autosnippet",
			dscr = "Auto vec",
			hidden = true,
		},
		fmta(
			[[\vb{<>}]],
			f(function(_, snip)
				return snip.captures[1]
			end)
		)
	),
	s(
		{ trig = "(%u)%1", snippetType = "autosnippet", regTrig = true, hidden = true },
		fmta(
			[[\mathcal{<>}]],
			f(function(_, snip)
				return snip.captures[1]
			end)
		)
	),
	s(
		{
			trig = [[(\S+)(]] .. suffix_match .. ")", -- TODO: Matches from `suffs` table
			trigEngine = "ecma",
			snippetType = "autosnippet",
			dscr = "Auto suffix",
			hidden = true,
		},
		fmta([[\<>{<>}]], {
			f(function(_, snip)
				return suffs[snip.captures[2]]
			end),
			f(function(_, snip)
				return snip.captures[1]
			end),
		})
	),
	-- TODO: Triangle matrix macro where you get to choose upper and lower part
	-- TODO: Macro for aligned environment that automagically adds the <> &= <> \\
}

ls.add_snippets("tex", tex.snippets, { key = "tex-snips" })

-- Make all the markdown snippets for admonition
local ads = {
	"note",
	"abstract",
	"info",
	"tip",
	"success",
	"question",
	"warning",
	"failure",
	"danger",
	"bug",
	"example",
	"quote",
	"definition",
	"theorem",
	"exercise",
	"proof",
}

local rec_callout
rec_callout = function()
	return sn(
		nil,
		c(1, {
			t(""),
			sn(nil, {
				t({ "", "> " }),
				i(1),
				d(2, rec_callout, {}),
			}),
		})
	)
end

local ad_snips = {}
for _, k in ipairs(ads) do
	table.insert(
		ad_snips,
		s({
			trig = k,
			dscr = "Add a " .. k .. " callout",
			docstring = { ">[!" .. k .. "] <title> ", "> ... ", "> ^" .. k },
		}, {
			t({ ">[!" .. k .. "] " }),
			i(1, "", { key = "snip-title" }),
			t({ "", "> " }),
			i(2),
			t({ "", "> " }),
			c(3, {
				t(""),
				f(function(args, _, _)
					return "(" .. k .. ":: " .. args[1][1] .. ") ^" .. k .. "-" .. args[1][1]:lower():gsub("%s+", "-")
				end, key("snip-title")),
			}),
			t({ "", "" }),
			i(0),
		})
	)
end

ls.add_snippets("markdown", ad_snips, { key = "ad-snips" })
ls.add_snippets("markdown", tex.snippets, { key = "md-tex-snips" })
ls.add_snippets("markdown", {
	s(
		{ trig = "align", show_condition = tex.in_text },
		fmt(
			[[ 
$$
\begin{{aligned}}
{}
\end{{aligned}}
$$

    ]],
			{ i(1) }
		)
	),
	s(
		{ trig = "align", show_condition = tex.in_mathzone },
		fmt(
			[[ 
\begin{{aligned}}
{}
\end{{aligned}}

    ]],
			{ i(1) }
		)
	),
}, { key = "md-snips" })

vim.api.nvim_set_keymap("i", "<C-j>", "<Plug>luasnip-next-choice", { silent = true })
vim.api.nvim_set_keymap("i", "<C-k>", "<Plug>luasnip-prev-choice", { silent = true })

vim.keymap.set({ "i", "s" }, "<C-l>", function()
	if ls.expandable() then
		ls.expand()
	elseif ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/configs/snippets.lua<CR>")
