vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>p', vim.cmd.Ex)

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

