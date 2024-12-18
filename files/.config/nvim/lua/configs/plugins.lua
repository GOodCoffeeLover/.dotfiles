local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "navarasu/onedark.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require('onedark').setup {
                style = 'warmer',
                toggle_style_key = "TT",
                toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'},
            }
            require('onedark').load()
        end,
    },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 }, -- color theme
    { "Mofiqul/vscode.nvim" }, -- color theme
    { "phaazon/hop.nvim" },
    { "ThePrimeagen/vim-be-good" },
    { "christoomey/vim-tmux-navigator" },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "s1n7ax/nvim-window-picker",
            "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
    },
{
  "vhyrro/luarocks.nvim",
  priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
  config = true,
},
    {
        "3rd/image.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            {"vhyrro/luarocks.nvim"},
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        opts = {
            highlight = { enable = true },
        },
    } ,
    -- Auto-save
    {
        "Pocco81/auto-save.nvim",
        config = function()
            require("auto-save").setup {
                -- enabled = false, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
                execution_message = {
                    message = function() -- message to print on save
                        return ("AutoSave: was saved at " .. vim.fn.strftime("%H:%M:%S"))
                    end,
                    dim = 0.18, -- dim the color of `message`
                    cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
                },
                trigger_events = {"InsertLeave", "TextChanged"}, -- vim events that trigger auto-save. See :h events
                -- function that determines whether to save the current buffer or not
                -- return true: if buffer is ok to be saved
                -- return false: if it's not ok to be saved
                condition = function(buf)
                    local fn = vim.fn
                    local utils = require("auto-save.utils.data")
                    if fn.getbufvar(buf, "&modifiable") ~= 1 then
                        return false
                    end

                    if not utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
                        return  false -- met condition(s), can save
                    end

                    local errors_count = 0
                    local dd = vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.ERROR })
                    for ds in pairs(dd) do
                        print(ds)
                        errors_count = errors_count + 1
                    end

                    if errors_count ~= 0 then
                        return false
                    end

                    return true -- can save
                end,
                write_all_buffers = false, -- write all buffers when the current one meets `condition`
                debounce_delay = 5000, -- saves the file at most every `debounce_delay` milliseconds
                callbacks = { -- functions to be executed at different intervals
                enabling = nil, -- ran when enabling auto-save
                disabling = nil, -- ran when disabling auto-save
                before_asserting_save = nil, -- ran before checking `condition`
                before_saving = nil, -- ran before doing the actual save
                after_saving = nil -- ran after doing the actual save
            },
        }
    end,
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function ()
            require('gitsigns').setup({
                signs = {
                    add          = { text = '┃' },
                    change       = { text = '┃' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked    = { text = '┆' },
                },

                signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
                numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
                linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
                word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
                watch_gitdir = {
                    follow_files = true
                },
                auto_attach = true,
                attach_to_untracked = false,
                current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                    delay = 100,
                    ignore_whitespace = false,
                    virt_text_priority = 100,
                },
                current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil, -- Use default
                max_file_length = 40000, -- Disable if file is longer than this (in lines)
                preview_config = {
                    -- Options passed to nvim_open_win
                    border = 'single',
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1
                },
            })
        end
    },
    { "diogo464/kubernetes.nvim" },
    {
      "folke/trouble.nvim",
      opts = {}, -- for default options, refer to the configuration section for custom setup.
      cmd = "Trouble",
      keys = {
        {
          "<leader>cs",
          "<cmd>Trouble symbols toggle focus=false<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>cl",
          "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
      },
    },
    -- LSP support
    { "neovim/nvim-lspconfig"},
    {
        "williamboman/mason.nvim",
        dependencies = {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        -- TODO: there's an option to specify dependecies right in this section, there's no need for another plugin (like "mason-tool-installer")
    },
    { "williamboman/mason-lspconfig.nvim" },
    -- Autocompletion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lua" },

    -- Snippets
    { "L3MON4D3/LuaSnip" },
    { "rafamadriz/friendly-snippets" },

    -- Linting & formatting
    { "nvimtools/none-ls.nvim" },

    -- DAP support
    { "mfussenegger/nvim-dap" },
    { "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        },
    },
    -- DAP Go with ease
    {
        "leoluz/nvim-dap-go",
        ft = "go",
        dependencies = "mfussenegger/nvim-dap",
        config = function(_, opts)
            require("dap-go").setup(opts)
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = "mfussenegger/nvim-dap",
        config = function(_, opts)
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
            require("dap-python").setup(path)
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-live-grep-args.nvim",
                version = "^1.0.0",
            },
        },
        config = function()
            require("telescope").load_extension("live_grep_args")
        end,
    },
    { "windwp/nvim-autopairs" },
    { "akinsho/bufferline.nvim", dependencies = "nvim-tree/nvim-web-devicons" },
    {
        "someone-stole-my-name/yaml-companion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
    },
    { "b0o/schemastore.nvim" },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
    },
    {
        "ray-x/go.nvim",
        dependencies = {  -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup()
        end,
        event = {"CmdlineEnter"},
        ft = {"go", 'gomod'},
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            highlight = {
                pattern = [[.*<(KEYWORDS)\s*(\([a-zA-Z0-9\s]*\))?\s*:]],
                -- pattern = [[.*<(KEYWORDS)\s*:]],
            },
        },
    },
    {
        "akinsho/git-conflict.nvim",
        version = "*",
    },
    {
        "sindrets/diffview.nvim",
    },
    {
        "lukas-reineke/headlines.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    -- colored identations
    { "lukas-reineke/indent-blankline.nvim" },
})

