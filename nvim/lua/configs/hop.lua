local hop = require("hop")

hop.setup()

local hop_leader = "<leader>h"
local mega_hop_leader = "<leader>H" -- TODO: combine more functionally
-- Way this would work is by wrapping the call in a function()

vim.keymap.set("n", hop_leader .. "s", hop.hint_char1)
vim.keymap.set("n", hop_leader .. "S", hop.hint_char2)

vim.keymap.set("n", hop_leader .. "l", hop.hint_lines_skip_whitespace)
vim.keymap.set("n", hop_leader .. "L", hop.hint_lines)

vim.keymap.set("n", hop_leader .. "p", hop.hint_patterns)
vim.keymap.set("n", hop_leader .. "w", hop.hint_words)
