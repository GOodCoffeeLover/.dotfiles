vim.cmd([[packadd packer.nvim]])

require('packer').startup(function(use)
    -- Packer can manage itself
    use { 'wbthomason/packer.nvim' }
    use { 'christoomey/vim-tmux-navigator' }
    -- статусбар, аналог vim-airline, только написан на lua
    use { 'nvim-lualine/lualine.nvim' }
    -- отображение буфферов/табов в верхнем горизонтальном меню
    -- автоматические закрывающиеся скобки
    use {'windwp/nvim-autopairs' }
    use {'fatih/vim-go' }

    use { 'nvim-treesitter/nvim-treesitter', {run = ':TSUpdate' }}
    use { 'akinsho/bufferline.nvim' }

    use { 'rebelot/kanagawa.nvim' }
    use { 'catppuccin/nvim', {as = 'catppuccin'} }
    use { 'navarasu/onedark.nvim' }

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        requires = { 
            {'nvim-lua/plenary.nvim'},
        }
    }
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            {'neovim/nvim-lspconfig'},
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'L3MON4D3/LuaSnip'},
        }
    }
    use {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        requires = { 
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
            'MunifTanjim/nui.nvim',
        }
    }
end)
