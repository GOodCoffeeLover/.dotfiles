vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>p', vim.cmd.Ex)

local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
vim.keymap.set('n', '<C-f>', telescope_builtin.git_files, {})
vim.keymap.set('n', '<leader>fs', function()
    telescope_builtin.grep_string({ search = vim.fn.input('grep > ') });
end)
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
vim.keymap.set('n', '<C-Space>', function ()
    vim.cmd([[:Neotree toggle]])
end)

vim.keymap.set('n', '<leader>bb', telescope_builtin.buffers, {})

vim.keymap.set('n', '<leader>o', telescope_builtin.oldfiles, {})

