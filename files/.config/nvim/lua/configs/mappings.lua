vim.g.mapleader = ' '
-- vim.keymap.set('n', '<leader>p', vim.cmd.Ex)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set("n", "<C-Space>", ":Neotree toggle reveal_force_cwd<CR>", {})

local key = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
key("i", "<c-l>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
key("s", "<c-l>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
key("i", "<c-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)
key("s", "<c-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)

-- TODO: check https://github.com/numToStr/Comment.nvim

key("n", "<leader>gf", ":GoFillStruct<CR>", opts)

vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
vim.keymap.set("n", "gr", function() require("trouble").toggle("lsp_references") end)
vim.keymap.set("n", "gi", function() require("trouble").toggle("lsp_implementations") end)

vim.api.nvim_set_keymap("n", "<leader>as", ":ASToggle<CR>", {})
