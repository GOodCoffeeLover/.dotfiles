local ts = require("nvim-treesitter")

local languages = {
    -- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
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
    -- "markdown",
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
}

ts.setup({})
-- If parser install fails with ENOENT "tree-sitter", fix with:
-- brew install tree-sitter-cli
ts.install(languages)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})
