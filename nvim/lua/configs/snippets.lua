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
local postfix = require("luasnip.extras.postfix").postfix
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")
local key = require("luasnip.nodes.key_indexer").new_key

local notify = require("notify")

local function idty(args)
	return args
end

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

local ts_utils = require("nvim-treesitter.ts_utils")
local parsers = require("nvim-treesitter.parsers")

local function in_markdown_math()
	local bufnr = vim.api.nvim_get_current_buf()
	local cur = vim.api.nvim_win_get_cursor(0)
	local row, col = cur[1] - 1, cur[2]

	-- 1) Climb the tree looking for Markdown math node types
	local node = ts_utils.get_node_at_cursor(0, false)
	while node do
		local nt = node:type()
		if nt == "math_inline" or nt == "math_block" or nt == "inline_math" or nt == "display_math" then
			return true
		end
		node = node:parent()
	end

	local parser = parsers.get_parser(bufnr)
	if parser then
		local lang_tree = parser:language_for_range({ row, col, row, col })
		if lang_tree and lang_tree:lang() == "latex" then
			return true
		end
	end

	return false
end

local tex = {}
tex.in_mathzone = function()
	if vim.bo.filetype == "tex" or vim.bo.filetype == "latex" then
		return vim.fn["vimtex#syntax#in_mathzone"]() == 1
	else
		return in_markdown_math()
	end
end

tex.in_text = function()
	return not tex.in_mathzone()
end

local add_math = function(delim)
	return function(args, snip)
		if tex.in_text() then
			return delim
		else
			return ""
		end
	end
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
		table.insert(nodes, t({ " \\\\", "\t" }))
	end
	-- fix last node.
	nodes[#nodes] = t(" \\\\")
	return sn(nil, nodes)
end

-- dynamic node
-- generally, postfix comes in the form PRE-CAPTURE-POST, so in this case, arg1 is the "pre" text, arg2 the "post" text
local dynamic_postfix = function(_, parent, _, user_arg1, user_arg2)
	local capture = parent.snippet.env.POSTFIX_MATCH
	if #capture > 0 then
		return sn(
			nil,
			fmta(
				[[
        <><><><>
        ]],
				{ t(user_arg1), t(capture), t(user_arg2), i(0) }
			)
		)
	else
		local visual_placeholder = ""
		if #parent.snippet.env.SELECT_RAW > 0 then
			visual_placeholder = parent.snippet.env.SELECT_RAW
		end
		return sn(
			nil,
			fmta(
				[[
        <><><><>
        ]],
				{ t(user_arg1), i(1, visual_placeholder), t(user_arg2), i(0) }
			)
		)
	end
end

-- Define suffix modifiers
-- k: the trigger, v: sub
local suffs = {
	hat = "hat",
	til = "tilde",
	ove = "overline",
	bar = "bar",
	dd = "ddot",
	["dot"] = "dot",
	[".,"] = "vb",
	[",."] = "vb",
}

local function suffix_snippets(condition_fn)
	local suffix_snips = {}
	for k, v in pairs(suffs) do
		table.insert(
			suffix_snips,
			postfix(
				{
					trig = k,
					snippetType = "autosnippet",
					condition = condition_fn,
					match_pattern = "[%{%}%\\%w%.%_%-]+$",
				},
				{
					f(function(_, parent)
						return "\\" .. v .. "{" .. parent.snippet.env.POSTFIX_MATCH .. "}"
					end),
				}
				-- { d(1, dynamic_postfix, {}, { user_args = { "\\" .. v .. "{", "}" } }) }
			)
		)
	end
	return suffix_snips
end

local function math_snippets(condition_fn)
	local snips = {
		s(
			{
				trig = "(%d)int",
				name = "multi integrals",
				dscr = "please work",
				regTrig = true,
				hidden = true,
				condition = condition_fn,
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
		s(
			{ trig = "opti", snippetType = "autosnippet", condition = condition_fn },
			fmta(
				[[\begin{aligned}
    <> <>_{<>} \quad & <> \\ 
    \text{s.t.} \quad & <> 
\end{aligned}]],
				{
					i(1),
					c(2, { t([[\min]]), t([[\max]]), t([[\argmin]]), t([[\argmax]]) }),
					i(3),
					i(4),
					i(5),
				}
			),
			{}
		),
		s(
			{ trig = "uu", wordTrig = false, snippetType = "autosnippet", hidden = true, condition = condition_fn },
			fmta([[_{<>}]], { i(1) }),
			{}
		),
		s(
			{ trig = "ii", wordTrig = false, snippetType = "autosnippet", hidden = true, condition = condition_fn },
			fmta([[^{<>}]], { i(1) }),
			{}
		),
		s(
			{ trig = "is", wordTrig = false, snippetType = "autosnippet", hidden = true, condition = condition_fn },
			fmta([[^{*}]], {}),
			{}
		),
		s(
			{ trig = "inv", wordTrig = false, snippetType = "autosnippet", hidden = true, condition = condition_fn },
			fmta([[^{-1}]], {}),
			{}
		),
		s(
			{ trig = "tp", snippetType = "autosnippet", wordTrig = false, condition = condition_fn },
			fmta("^{\\transp}", {}),
			{} -- `condition` option passed in the snippet `opts` table
		),
		s({
			trig = "td",
			snippetType = "autosnippet",
			wordTrig = false,
			dscr = "conjugate transpose",
			condition = condition_fn,
		}, fmta([[^{\dagger}]], {})),
		s(
			{ trig = "rr", snippetType = "autosnippet", wordTrig = true, condition = condition_fn },
			fmta("\\mathbb{R}^{<>}", { i(1) })
		),
		s(
			{ trig = "irr", snippetType = "autosnippet", wordTrig = true, condition = condition_fn },
			fmta("\\in \\mathbb{R}^{<>}", { i(1) })
		),
		s(
			{ trig = "ff", snippetType = "autosnippet", condition = condition_fn },
			fmta("\\frac{<>}{<>}", {
				i(1),
				i(2),
			})
		),
		s(
			{ trig = "ee", snippetType = "autosnippet", condition = condition_fn },
			fmta("e^{<>}", {
				i(1),
			})
		),
		s(
			{

				trig = "([bBpvV])(%d+)x(%d+)(a?)",
				regTrig = true,
				name = "matrix",
				dscr = "arbitrary matrix gen snippet",
				hidden = true,
				condition = condition_fn,
			},
			fmta(
				[[
    <>
        <>
    <>]],
				{
					f(function(_, snip)
						if snip.captures[4] == "a" then
							local caps = string.rep("c", snip.captures[3])
							return sn(nil, fmta([[\begin{array}{@{}<><>@{}}]]), { i(1), t(caps) })
						else
							return "\\begin{" .. snip.captures[1] .. "matrix}" -- captures matrix type
						end
					end),
					d(1, mat),
					f(function(_, snip)
						if snip.captures[4] == "a" then
							return "\\end{array}"
						else
							return "\\end{" .. snip.captures[1] .. "matrix}" -- captures matrix type
						end
					end),
				}
			)
		),
		s(
			{
				trig = "(%b())/",
				regTrig = true,
				snippetType = "autosnippet",
				dscr = "() fraction",
				hidden = true,
				condition = condition_fn,
			},
			fmta([[\frac{<>}{<>}]], { f(function(_, snip)
				return snip.captures[1]:sub(2, -2)
			end), i(1) }),
			{}
		),
		s(
			{
				trig = "(%S+)/",
				regTrig = true,
				snippetType = "autosnippet",
				dscr = "fraction",
				hidden = true,
				condition = condition_fn,
			},
			fmta([[\frac{<>}{<>}]], { f(function(_, snip)
				return snip.captures[1]
			end), i(1) }),
			{}
		),
		s(
			{ trig = "align", snippetType = "autosnippet", hidden = false, condition = condition_fn },
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
		s({ trig = "bb", hidden = true, condition = condition_fn }, {
			t("\\mathbb{"),
			i(1),
			t("}"),
			i(0),
		}),
		s(
			{ trig = "lim", snippetType = "autosnippet", hidden = true, condition = condition_fn },
			fmta([[\lim_{<> \to <>}  <>]], {
				i(1, "t"),
				i(2, "\\infty"),
				i(3, "x(t)"),
			})
		),
		s(
			{ trig = "ip", snippetType = "autosnippet", condition = condition_fn },
			fmt([[\langle {}, {} \rangle]], {
				i(1, "u"),
				i(2, "v"),
			})
		),
		s({ trig = "cd", hidden = true, condition = condition_fn }, fmta([[\cdot]], {}), {}),
		s({ trig = "dc", hidden = true, condition = condition_fn }, fmta([[\dotsc]], {}), {}),
		s({ trig = "vd", hidden = true, condition = condition_fn }, fmta([[\vdot]], {}), {}),
		s(
			{ trig = "pd", snippetType = "autosnippet", condition = condition_fn },
			fmta([[\pdv{<>}<>]], {
				i(1),
				c(2, { fmta([[{<>}]], { i(1) }), i(nil) }),
			})
		),
		s(
			{ trig = "dv", snippetType = "autosnippet", condition = condition_fn },
			fmta([[\dv{<>}<>]], {
				i(1),
				c(2, { fmta([[{<>}]], { i(1) }), i(nil) }),
			})
		),
	}
	return snips
end

tex.snippets = {
	s({ trig = "ls" }, {
		t({ "\\begin{itemize}", "\t\\item " }),
		i(1),
		d(2, rec_ls, {}),
		t({ "", "\\end{itemize}" }),
	}),
	s({ trig = "beg" }, {
		t({ "\\begin{" }),
		i(1),
		t({ "}", "" }),
		i(2),
		f(function(args, _, _)
			return { "\t", "\\end{" .. args[1][1] .. "}" }
		end, { 1 }),
		i(0),
	}),
	s({ trig = "tit", hidden = true }, fmta([[\textit{<>}]], { i(1) }), { condition = tex.in_text }),
	s({ trig = "tbf", hidden = true }, fmta([[\textbf{<>}]], { i(1) }), { condition = tex.in_text }),
	s(
		{ trig = "nin", hidden = true },
		fmta([[<>n \in \N<>]], {
			f(add_math("$")),
			f(add_math("$")),
		})
	),
	s(
		{ trig = "([%\\]?[A-Za-z]+)(%d+)", regTrig = true, name = "auto subscript", hidden = true },
		fmta([[<><>_{<>}<>]], {
			f(add_math("$")),
			f(function(_, snip)
				return snip.captures[1] -- Identify if in math zone and add inline math delims
			end),
			f(function(_, snip)
				return snip.captures[2]
			end),
			f(add_math("$")),
		})
	),
	s({ trig = "nn", snippetType = "autosnippet" }, {
		t({ "\\begin{equation}\\label{eq:" }),
		i(1),
		t({ "}", "\t" }),
		i(2),
		t({ "", "\\end{equation}", "" }),
		i(0),
	}),
	s({ trig = "mt" }, {
		t({ "\\[", "\t" }),
		i(1),
		t({ "", "\\]" }),
		i(0),
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
		{ trig = "apl", snippetType = "autosnippet", wordTrig = true },
		fmta(
			[[\begin{enumerate}[label=(\alph*)]
    \item <> 
\end{enumerate}]],
			{ i(1) }
		)
	),
	s(
		{ trig = "arol", snippetType = "autosnippet", wordTrig = true },
		fmta(
			[[\begin{enumerate}[label=(\roman*)]
    \item <> 
\end{enumerate}]],
			{ i(1) }
		)
	),
	s(
		{ trig = "arl", snippetType = "autosnippet", wordTrig = true },
		fmta(
			[[\begin{enumerate}[label={\bf\arabic* }]
    \item <> 
\end{enumerate}]],
			{ i(1) }
		)
	),
	s(
		{ trig = "fun" },
		fmt([[${}: {} \to {}$]], {
			i(1, "\\varphi"),
			c(2, {
				i(nil),
				sn(nil, { t("\\mathbb{"), i(1), t("}") }),
			}),
			c(3, {
				i(nil),
				sn(nil, { t("\\mathbb{"), i(1), t("}") }),
			}),
		})
	),
	s(
		{ trig = "c(%u)%1", snippetType = "autosnippet", regTrig = true, hidden = true },
		fmta([[<>\mathcal{<>}<>]], {
			f(add_math("$")),
			f(function(_, snip)
				return snip.captures[1]
			end),
			f(add_math("$")),
		})
	),
}

-- Make all the environment / proof / theorems
local envs = {
	"definition",
	"eg",
	"notation",
	"previouslyseen",
	"remark",
	"note",
	"exercise",
	"observe",
	"property",
	"intuition",
	"prop",
	"theorem",
	"corollary",
	"lemma",
}

local env_snips = {}
for _, k in ipairs(envs) do
	table.insert(
		env_snips,
		s(
			{
				trig = k,
				dscr = "Start a " .. k .. "environment",
				docstring = { "\\begin{" .. k .. "}[<title>]", "...", "\\end{" .. k .. "}" },
				hidden = true,
			},
			fmta("\\begin{" .. k .. "}[<>]" .. "\n\t<>" .. "\n\\end{" .. k .. "}", {
				i(1),
				i(2),
			})
		)
	)
end

local greeks = {
	alp = "\\alpha",
	eps = "\\epsilon",
	veps = "\\varepsilon",
	sig = "\\sigma",
	the = "\\theta",
	gam = "\\gamma",
	del = "\\delta",
}

local function greek_snippets(condition_fn)
	local greek_snips = {}
	for k, v in pairs(greeks) do
		table.insert(
			greek_snips,
			s({
				trig = k,
				dscr = "Produce the greek letter " .. v,
				docstring = { v },
				hidden = true,
				snippetType = "autosnippet",
				condition = condition_fn,
			}, { t(v) }, {})
		)
	end
	return greek_snips
end

local delims = {
	a = { "\\langle", "\\rangle" },
	A = { "<", ">" },
	b = { "[", "]" },
	B = { "\\{", "\\}" },
	v = { "|", "|" },
	V = { "\\|", "\\|" },
	p = { "(", ")" },
}

local function delimiter_snippets(condition_fn)
	local lr_snips = {}
	for k, v in pairs(delims) do
		table.insert(
			lr_snips,
			s(
				{
					trig = "lr" .. k,
					dscr = "Left right paired" .. v[1],
					-- docstring = { v },
					hidden = true,
					snippetType = "autosnippet",
					condition = condition_fn,
				},
				fmta([[\left<> <> \right<>]], {
					t(v[1]),
					i(1),
					t(v[2]),
				})
			)
		)
	end
	return lr_snips
end

ls.add_snippets("tex", env_snips, { key = "theorem-envs" })
ls.add_snippets("tex", greek_snippets(tex.in_mathzone), { key = "tex-greeks" })
ls.add_snippets("tex", delimiter_snippets(tex.in_mathzone), { key = "tex-delimites" })
ls.add_snippets("tex", suffix_snippets(tex.in_mathzone), { key = "tex-postfixes" })
ls.add_snippets("tex", math_snippets(tex.in_mathzone), { key = "tex-math-snips" })
ls.add_snippets("tex", tex.snippets, { key = "tex-snips" })

ls.add_snippets("markdown", greek_snippets(tex.in_mathzone), { key = "md-greeks" })
ls.add_snippets("markdown", delimiter_snippets(tex.in_mathzone), { key = "md-delimites" })
ls.add_snippets("markdown", suffix_snippets(tex.in_mathzone), { key = "md-postfixes" })
ls.add_snippets("markdown", math_snippets(tex.in_mathzone), { key = "md-tex-math-snips" })
ls.add_snippets("markdown", tex.snippets, { key = "md-tex-snips" })

-------------------- Python Snippets --------------------
local function py_init()
	return sn(
		nil,
		c(1, {
			t(""),
			i(1),
		})
	)
end

local function init_assign(args)
	local tab = {}
	local a = args[1][1]
	if #a == 0 then
		table.insert(tab, t({ "", "\tpass" }))
	else
		local cnt = 1
		for e in string.gmatch(a, " ?([^,]*) ?") do
			if #e > 0 then
				table.insert(tab, t({ "", "\tself." }))
				table.insert(tab, t(e))
				table.insert(tab, t(" = "))
				table.insert(tab, t(e))
				cnt = cnt + 1
			end
		end
	end
	return sn(nil, tab)
end

local pysnips = {
	s(
		"init",
		fmt([[def __init__(self{}):{}]], {
			d(1, py_init),
			d(2, init_assign, { 1 }),
		})
	),
}

ls.add_snippets("python", pysnips, { key = "python snippets" })

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
