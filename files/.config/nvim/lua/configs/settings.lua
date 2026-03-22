-- Keybindings
vim.keymap.set('n', '<C-n>', ':bnext<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-p>', ':bprevious<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bd', ':bdelete<cr>', { noremap = true, silent = true })

-- Clear highlighting on escape in normal mode
vim.keymap.set('n', '<esc>', ':noh<return><esc>', { noremap = true, silent = true })
vim.keymap.set('n', '<esc>^[', '<esc>^[', { noremap = true, silent = true })

-- Navigation improvements
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })
vim.keymap.set('n', 'n', 'nzzzv', { noremap = true, silent = true })
vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true, silent = true })

-- Quick insertion
vim.keymap.set('n', '<C-Enter>', 'o<ESC>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Enter>', 'O<ESC>', { noremap = true, silent = true })

-- Editor Settings
local opt = vim.opt

opt.backup = false
opt.number = true
opt.relativenumber = true

-- Cursor line settings
opt.cursorline = true
opt.culopt = 'screenline'
vim.cmd('hi CursorLine term=none cterm=none ctermbg=238')

-- Search settings
opt.showmatch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- Indentation and tabs
opt.shiftwidth = 4    -- Number of spaces for each indent
opt.tabstop = 4       -- Number of columns for each tab character
opt.expandtab = true  -- Use spaces instead of tabs

-- Backup and swap files
opt.backup = false
opt.swapfile = true
opt.dir = '/tmp'

-- Display settings
opt.scrolloff = 10    -- Keep 10 lines visible when scrolling
opt.wrap = false      -- Don't wrap lines
opt.showcmd = true    -- Show partial commands
opt.showmode = true   -- Show current mode
opt.wildmenu = true   -- Enhanced command completion
opt.wildmode = 'list:longest'

-- Files to ignore in wildmenu completion
opt.wildignore = {
  '*.docx', '*.jpg', '*.png', '*.gif', '*.pdf',
  '*.pyc', '*.exe', '*.flv', '*.img', '*.xlsx'
}

-- Command history
opt.history = 1000

-- Window splitting
opt.splitbelow = true  -- Split windows below current window
opt.splitright = true  -- Split windows to the right of current window

-- Clipboard settings
opt.clipboard = 'unnamedplus' -- Shared clipboard with system

-- Folding settings
opt.fillchars = { fold = ' ' }
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldlevel = 99
opt.foldnestmax = 4

-- Custom fold text function
function _G.foldtext()
  local snippet = vim.fn.getline(vim.v.foldstart)
  local folded_count = (vim.v.foldend - vim.v.foldstart + 1)
  return string.format('> %s |  folded %d lines...', snippet, folded_count)
end

opt.foldtext = 'v:lua.foldtext()'

-- Markdown preview function
function _G.open_markdown_preview(url)
  -- Try Linux command first
  vim.fn.execute('silent ! firefox --new-window ' .. url)
  -- Try macOS command
  vim.fn.execute('silent ! open -a Firefox -n --args --new-window ' .. url)
end

vim.g.mkdp_browserfunc = 'v:lua.open_markdown_preview'

-- Custom diagnostic handler for strikethrough deprecated
vim.diagnostic.handlers["strikethrough"] = {
  show = function(namespace, bufnr, diagnostics, _)
    local ns = vim.diagnostic.get_namespace(namespace)

    if not ns.user_data.strikethrough_ns then
      ns.user_data.strikethrough_ns = vim.api.nvim_create_namespace("")
    end

    local higroup = "DiagnosticStrikethroughDeprecated"
    local strikethrough_ns = ns.user_data.strikethrough_ns

    for _, diagnostic in ipairs(diagnostics) do
      local user_data = diagnostic.user_data

      if user_data and user_data.lsp.tags and vim.tbl_contains(user_data.lsp.tags, 2) then
        vim.highlight.range(
          bufnr,
          strikethrough_ns,
          higroup,
          { diagnostic.lnum, diagnostic.col },
          { diagnostic.end_lnum, diagnostic.end_col }
        )
      end
    end
  end,
  hide = function(namespace, bufnr)
    local ns = vim.diagnostic.get_namespace(namespace)

    if ns.user_data.strikethrough_ns then
      vim.api.nvim_buf_clear_namespace(bufnr, ns.user_data.strikethrough_ns, 0, -1)
    end
  end,
}

-- Create autocommand group for diagnostic strikethrough
local diagnostic_strikethrough_group = vim.api.nvim_create_augroup('diagnostic_strikethrough_deprecated', { clear = true })

vim.api.nvim_create_autocmd('ColorScheme', {
  group = diagnostic_strikethrough_group,
  pattern = '*',
  callback = function()
    vim.cmd('highlight DiagnosticStrikethroughDeprecated gui=strikethrough')
  end,
})