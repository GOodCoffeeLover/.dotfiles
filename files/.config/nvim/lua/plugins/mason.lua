require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
    ensure_installed = {
        "ansible-language-server",
        "ansible-lint",
        "autopep8",
        "autotools-language-server",
        "bash-language-server",
        "black",
        "buf",
        "buf-language-server",
        "dagger",
        "debugpy",
        "delve",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "goimports",
        "gopls",
        "helm-ls",
        "jinja-lsp",
        "json-lsp",
        "lua-language-server",
        "marksman",
        "mypy",
        "pylint",
        "pyright",
        "ruff",
        "salt-lint",
        "selene",
        "snyk",
        "sqlfmt",
        "sqls",
        "staticcheck",
        "stylua",
        -- "terraform-ls",
        "tflint",
        "yaml-language-server",
        "yamlfmt",
        "yamllint",
    },
    auto_update = false,
})
