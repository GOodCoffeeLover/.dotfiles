require("nvim-treesitter.configs").setup({
    ensure_installed = {
        -- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#available-modules
        "bash",
        "c",
        "cue",
        "css",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",
        "hcl",
        "helm",
        "html",
        "ini",
        "json",
        "lua",
        "make",
        --"markdown",
        "proto",
        "python",
        "sql",
        "terraform",
        "tmux",
        "xml",
        "yaml",
        "vim",
        "vimdoc",
        "query",

    },
    ignore_install = {},
    modules = {},
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})
