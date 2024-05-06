-- own cofigs
require('configs.colors')
require('configs.mappings')
require('configs.plugins')
require('configs.settings')

-- plugins
require('plugins.neo-tree')
require('plugins.telescope')
require('plugins.treesitter')


require('lualine')
require('nvim-autopairs').setup()
require('bufferline')


local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({buffer = bufnr})
end)
lsp_zero.setup_servers({'gopls', 'pylyzer', 'lua_ls'})

local cmp = require('cmp')
cmp.setup({
    sources = {
        {name = 'nvim_lsp'},
    },
    mapping = {
        ['<Enter>'] = cmp.mapping.confirm({select = false}),
        ['<Esc>'] = cmp.mapping.abort(),
        ['<Up>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
        ['<Down>'] = cmp.mapping.select_next_item({behavior = 'select'}),
        ['<C-p>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item({behavior = 'insert'})
            else
                cmp.complete()
            end
        end),
        ['<C-n>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_next_item({behavior = 'insert'})
            else
                cmp.complete()
            end
        end),
    }
})




