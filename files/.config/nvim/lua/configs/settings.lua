vim.cmd([[
map <leader>bn :bnext<cr>
map <leader>bp :bprevious<cr>
map <leader>bd :bdelete<cr>

set nobackup
set number relativenumber

set cursorline " cursorcolumn
set cul
set culopt=screenline
hi CursorLine term=none cterm=none ctermbg=238

set showmatch

set swapfile
set dir=/tmp

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Use space characters instead of tabs.
set expandtab

" Do not save backup files.
set nobackup

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=10

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=1000

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Clear highlighting on escape in normal mode
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[

nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-Enter> o<ESC>
nnoremap <S-Enter> O<ESC>

set splitbelow
set splitright
]])

vim.opt.clipboard = "unnamedplus" -- SHARED clipboard with the system

vim.diagnostic.handlers["strikethrough"] = {
    show = function(namespace, bufnr, diagnostics, _)
        local ns = vim.diagnostic.get_namespace(namespace)

        if not ns.user_data.strikethrough_ns then
            ns.user_data.strikethrough_ns = vim.api.nvim_create_namespace ""
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

vim.cmd [[
augroup diagnostic_strikethrough_deprecated
    autocmd!
    autocmd ColorScheme * highlight DiagnosticStrikethroughDeprecated gui=strikethrough
augroup END
]]
