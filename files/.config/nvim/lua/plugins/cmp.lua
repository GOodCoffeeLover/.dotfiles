-- Filetype autodetect
-- array or "none", "single", "double", "rounded", "solid", "shadow"
local _border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" }
local _cmp_border = 'rounded'

vim.api.nvim_command("autocmd BufRead,BufNewFile *.sls set filetype=sls")


-- Set up nvim-cmp.
local cmp = require("cmp")
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),

    sources = cmp.config.sources(
        {
            { name = "nvim_lsp" },
            { name = "nvim_lsp_signature_help" },
            { name = "luasnip" }, -- For luasnip users.
        },
        {
            { name = "buffer" },
        }
    ),
    window = {
        completion = {
            border = _cmp_border,
            scrollbar = '',
        },
        documentation = {
            border = _cmp_border,
            scrollbar = '',
        },
    },
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
        { name = "buffer" },
    }),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
    matching = { disallow_symbol_nonprefix_matching = false },
})

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = {
    "bashls",
    "buf_ls",
    "jsonls",
    "helm_ls",
    "sqls",
}

-- lsps with default config
for _, lsp in ipairs(servers) do
    vim.lsp.config(lsp, {
        capabilities = capabilities,
    })
    vim.lsp.enable(lsp)
end

-- lsps configured below: lua, go

vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = {
                globals = {
                    "vim",
                },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    },
})
vim.lsp.enable("lua_ls")

vim.lsp.config("gopls", {
    capabilities = capabilities,
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
    settings = {
        gopls = {
            completeUnimported = true,
            -- enables placeholders with the function signature/parameters when autocompleted (e.g. make -> make(type, 0))
            usePlaceholders = true,
            -- there's much more static analysis tools provided by gopls
            -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
            analyses = {
                unusedparams = true,
                deprecated = true,
            },
            staticcheck = true,
            gofumpt = true,
            hints = {
                rangeVariableTypes = true,
                parameterNames = true,
                constantValues = true,
                assignVariableTypes = false,
                compositeLiteralFields = true,
                compositeLiteralTypes = false,
                functionTypeParameters = true,
            },

        },
    },
})
vim.lsp.enable("gopls")

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }
        -- buf_request_sync defaults to a 1000ms timeout. Depending on your
        -- machine and codebase, you may want longer. Add an additional
        -- argument after params if you find that you have to write the file
        -- twice for changes to be saved.
        -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
        for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
            end
        end
        vim.lsp.buf.format({ async = false })
    end
})

vim.lsp.config("pyright", {
    capabilities = capabilities,
    filetypes = { "python" },
})
vim.lsp.enable("pyright")

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>E", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)


local function with_border(handler)
    return function(err, result, ctx, config)
        config = vim.tbl_deep_extend("force", config or {}, { border = _border })
        return handler(err, result, ctx, config)
    end
end

vim.lsp.handlers["textDocument/hover"] = with_border(vim.lsp.handlers.hover)
vim.lsp.handlers["textDocument/signatureHelp"] = with_border(vim.lsp.handlers.signature_help)

vim.diagnostic.config {
    float = { border = _border }
}

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),

    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        -- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover({ border = _border })
        end, opts)
        vim.keymap.set("n", "<C-s>", function()
            vim.lsp.buf.signature_help({ border = _border })
        end, opts)
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        -- vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
        end, opts)
    end,
})

local kubernetes_schema_generation_requested = false
local kubernetes_gvk_schema_index = nil

local function resolve_kubernetes_schema()
    local kubernetes_ok, kubernetes = pcall(require, "kubernetes")
    if not kubernetes_ok then
        return nil
    end

    local schema_ok, schema_uri = pcall(kubernetes.yamlls_schema)
    if not schema_ok or type(schema_uri) ~= "string" then
        return nil
    end

    local schema_path = schema_uri:gsub("^file://", "")
    if vim.fn.filereadable(schema_path) == 1 then
        return schema_uri
    end

    if not kubernetes_schema_generation_requested then
        kubernetes_schema_generation_requested = true
        pcall(kubernetes.generate_schema)
    end

    return nil
end

local function parse_yaml_api_version_and_kind(lines)
    local api_version = nil
    local kind = nil
    for _, line in ipairs(lines) do
        if not api_version then
            local m = line:match("^%s*apiVersion%s*:%s*([%w%._%-%/]+)%s*$")
            if m then
                api_version = m
            end
        end
        if not kind then
            local m = line:match("^%s*kind%s*:%s*([%w%._%-]+)%s*$")
            if m then
                kind = m
            end
        end
        if api_version and kind then
            return api_version, kind
        end
    end
    return nil, nil
end

local function build_kubernetes_gvk_schema_index(kubernetes_schema)
    if kubernetes_gvk_schema_index then
        return kubernetes_gvk_schema_index
    end

    local schema_path = kubernetes_schema:gsub("^file://", "")
    local schema_dir = vim.fn.fnamemodify(schema_path, ":h")
    local definitions_path = schema_dir .. "/definitions.json"
    if vim.fn.filereadable(definitions_path) ~= 1 then
        return nil
    end

    local decoded = vim.json.decode(table.concat(vim.fn.readfile(definitions_path), "\n"))
    if type(decoded) ~= "table" or type(decoded.definitions) ~= "table" then
        return nil
    end

    local index = {}
    local base_uri = "file://" .. definitions_path .. "#/definitions/"
    for def_name, def_body in pairs(decoded.definitions) do
        if type(def_body) == "table" and type(def_body["x-kubernetes-group-version-kind"]) == "table" then
            for _, gvk in ipairs(def_body["x-kubernetes-group-version-kind"]) do
                if type(gvk) == "table" and type(gvk.kind) == "string" and type(gvk.version) == "string" then
                    local group = type(gvk.group) == "string" and gvk.group or ""
                    local key = group .. "/" .. gvk.version .. "#" .. gvk.kind
                    if not index[key] then
                        index[key] = base_uri .. def_name
                    end
                end
            end
        end
    end

    kubernetes_gvk_schema_index = index
    return index
end

local yaml_schemas = {
    ["https://json.schemastore.org/kustomization.json"] = { "kustomization.yaml", "kustomization.yml", "/kustomization.yaml", "/kustomization.yml", "**/kustomization.yaml", "**/kustomization.yml" },
    ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/tasks"] = { "roles/tasks/*.yaml", "roles/tasks/*.yml", "/roles/tasks/*.yaml", "/roles/tasks/*.yml", "**/roles/tasks/*.yaml", "**/roles/tasks/*.yml" },
    ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook"] = { "*play*.yaml", "*play*.yml", "*/play*.yaml", "*/play*.yml", "**/*play*.yaml", "**/*play*.yml" },
    ["https://json.schemastore.org/chart.json"] = { "Chart.yaml", "Chart.yml", "/Chart.yaml", "/Chart.yml", "**/Chart.yaml", "**/Chart.yml" },
}

local yamlls_cfg = {
    capabilities = capabilities,
    settings = {
        yaml = {
            schemas = yaml_schemas,
            schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
            },
            schemaDownload = { enable = true },
            format = { enable = false },
            -- anabling this conflicts between Kubernetes resources and kustomization.yaml and Helmreleases
            -- see utils.custom_lsp_attach() for the workaround
            -- how can I detect Kubernetes ONLY yaml files? (no CRDs, Helmreleases, etc.)
            validate = true,
            completion = true,
            hover = true,
            keyOrdering = false,
        },
    },
}

vim.lsp.config("yamlls", yamlls_cfg)
vim.lsp.enable("yamlls")

local function maybe_attach_kubernetes_schema(bufnr)
    local kubernetes_schema = resolve_kubernetes_schema()
    if not kubernetes_schema then
        return
    end

    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t"):lower()
    if filename == "kustomization.yaml" or filename == "kustomization.yml" or filename == "chart.yaml" or filename == "chart.yml" then
        return
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, math.min(200, vim.api.nvim_buf_line_count(bufnr)), false)
    local api_version, kind = parse_yaml_api_version_and_kind(lines)
    if not (api_version and kind) then
        return
    end

    local group, version = "", api_version
    local slash = api_version:find("/", 1, true)
    if slash then
        group = api_version:sub(1, slash - 1)
        version = api_version:sub(slash + 1)
    end

    local schema_for_buffer = kubernetes_schema
    local gvk_index = build_kubernetes_gvk_schema_index(kubernetes_schema)
    if gvk_index then
        local gvk_key = group .. "/" .. version .. "#" .. kind
        if type(gvk_index[gvk_key]) == "string" then
            schema_for_buffer = gvk_index[gvk_key]
        end
    end

    local bufuri = vim.uri_from_bufnr(bufnr)
    local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "yamlls" })
    for _, client in ipairs(clients) do
        local settings = vim.deepcopy(client.settings or {})
        settings.yaml = settings.yaml or {}
        settings.yaml.schemas = settings.yaml.schemas or {}

        for schema_uri, target in pairs(settings.yaml.schemas) do
            if target == bufuri and type(schema_uri) == "string" and schema_uri:find("/kubernetes.nvim/", 1, true) then
                settings.yaml.schemas[schema_uri] = nil
            end
        end

        settings.yaml.schemas[schema_for_buffer] = bufuri
        client.settings = settings
        client:notify("workspace/didChangeConfiguration", { settings = settings })
    end
end

vim.api.nvim_create_autocmd({ "LspAttach", "BufWritePost" }, {
    pattern = { "*.yaml", "*.yml" },
    callback = function(ev)
        maybe_attach_kubernetes_schema(ev.buf)
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.yaml", "*.yml" },
    callback = function(ev)
        vim.defer_fn(function()
            if vim.api.nvim_buf_is_valid(ev.buf) then
                maybe_attach_kubernetes_schema(ev.buf)
            end
        end, 1200)
    end,
})

vim.api.nvim_create_user_command("YamllsSchemaInfo", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "yamlls" })
    if #clients == 0 then
        vim.notify("yamlls is not attached to current buffer", vim.log.levels.WARN)
        return
    end

    local responses = vim.lsp.buf_request_sync(bufnr, "yaml/get/jsonSchema", { vim.uri_from_bufnr(bufnr) }, 1200)
    if type(responses) ~= "table" then
        vim.notify("yamlls did not return schema info", vim.log.levels.WARN)
        return
    end

    local schema = nil
    for _, resp in pairs(responses) do
        if type(resp) == "table" and type(resp.result) == "table" and type(resp.result[1]) == "table" then
            schema = resp.result[1]
            break
        end
    end

    if not schema then
        vim.notify("No active YAML schema for current buffer", vim.log.levels.INFO)
        return
    end

    local name = schema.name or "unnamed"
    local uri = schema.uri or "unknown-uri"
    vim.notify(("yamlls schema: %s\n%s"):format(name, uri), vim.log.levels.INFO)
end, { desc = "Show active yamlls schema for current buffer" })

vim.api.nvim_create_user_command("YamllsSchemaDump", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "yamlls" })
    if #clients == 0 then
        vim.notify("yamlls is not attached to current buffer", vim.log.levels.WARN)
        return
    end

    local schemas = (((clients[1] or {}).settings or {}).yaml or {}).schemas or {}
    local lines = vim.split(vim.inspect(schemas), "\n", { plain = true })

    vim.cmd("new")
    local out = vim.api.nvim_get_current_buf()
    vim.bo[out].buftype = "nofile"
    vim.bo[out].bufhidden = "wipe"
    vim.bo[out].swapfile = false
    vim.bo[out].filetype = "lua"
    vim.api.nvim_buf_set_name(out, "yamlls-schema-dump")
    vim.api.nvim_buf_set_lines(out, 0, -1, false, lines)
end, { desc = "Dump current yamlls schema mappings to a scratch buffer" })

vim.lsp.config("terraformls", {
    capabilities = capabilities,
    settings = {
        filetypes = {"terraform", "tf", "terraform-vars"}
    }
})
vim.lsp.enable("terraformls")
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.lsp.buf.format()
  end,
})
