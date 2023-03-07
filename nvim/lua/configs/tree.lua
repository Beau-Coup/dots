require('nvim-tree').setup {
    sort_by = "case_sensitive",
    hijack_cursor = true,
    renderer = {
        special_files = {},
        icons = {
            git_placement = "after",
            symlink_arrow = " -> ",
            padding = "",
            glyphs = {
                default = "",
                symlink = "",
                bookmark = "",
                folder = {
                    arrow_closed = "+",
                    arrow_open = "-",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = "",
                },
                git = {
                    unstaged = "M",
                    staged = "M",
                    unmerged = "U",
                    renamed = "R",
                    untracked = "?",
                    deleted = "D",
                    ignored = "-",
                },
            },
        },
    },
    view = {
        width = 28,
        mappings = {
            custom_only = true,
            list = {
                { key = { "<CR>", "o", "<2-LeftMouse>", "l" }, action = "edit" },
                { key = "<F5>",                                action = "refresh" },
                { key = "h",                                   action = "close_node" },
                { key = "d",                                   action = "remove" },
                { key = "q",                                   action = "close" },
                { key = "r",                                   action = "rename" },
                { key = "N",                                   action = "create" },
                { key = "K",                                   action = "toggle_file_info" },
            },
        },
    },
    git = {
        ignore = false,
    },
}
