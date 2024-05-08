require("telescope").setup({
    -- https://www.reddit.com/r/neovim/comments/16ikt0q/telescope_live_grep_search_some_hidden_files/?rdt=52142
    defaults = {
        file_ignore_patterns = {
            "node_modules",
            "__pycache__",
            "package-lock.json",
            ".git",
            ".venv",
            -- work
            "projects/webview/specs",
        },
    },
    pickers = {
        find_files = {
            hidden = true,
        },
        live_grep = {
            additional_args = function(_)
                return { "--hidden" }
            end,
        },
    },
})
