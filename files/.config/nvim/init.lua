-- own cofigs
require('configs.plugins')
require('configs.mappings')
require('configs.settings')
require('configs.colors')

-- plugins
require('plugins.bufferline')
require('plugins.cmp')
require('plugins.dap')
require('plugins.diffview')
require('plugins.go')
require('plugins.indent-blankline')
require('plugins.mason')
require('plugins.neo-tree')
require('plugins.telescope')
require('plugins.treesitter')

require('nvim-autopairs').setup()

