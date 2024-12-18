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

key("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", {})
key("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", {})
key("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", {})
key("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", {})
vim.keymap.set("n", "gr", function() require("trouble").toggle("lsp_references") end)
vim.keymap.set("n", "gi", function() require("trouble").toggle("lsp_implementations") end)
vim.keymap.set("n", "gd", function() require("trouble").toggle("lsp_definitions") end)
vim.keymap.set("n", "gD", function() require("trouble").toggle("lsp_declarations") end)
vim.keymap.set("n", "D", function() require("trouble").toggle("lsp_type_definitions") end)

vim.api.nvim_set_keymap("n", "<leader>as", ":ASToggle<CR>", {})
