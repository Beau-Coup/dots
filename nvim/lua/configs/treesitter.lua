require('nvim-treesitter.configs').setup {
    ensure_installed = "all",
    ignore_install = {},
    highlight = {
        enable = true,
        disable = { "latex", "lua" },
    },
    textobjects = {
        select = {
            enable = true,
            include_surrounding_whitespace = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["ac"] = "@conditional.outer",
                ["ic"] = "@conditional.inner",
            },
            selection_modes = {},
        },
        move = {
            enable = true,
            disable = { 'tex', 'latex' },
            set_jumps = true,
            goto_next_start = {
                ["]m"] = "@function.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
            },
        },
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
        commentary_integration = {
            Commentary = false,
            CommentaryLine = false,
            ChangeCommentary = false,
            CommentaryUndo = false,
        }
    },
}
