local dap_go = require("dap-go")

local map = vim.keymap.set

vim.cmd("autocmd FileType go lua MapGo()")
vim.cmd("autocmd FileType py lua MapPython()")

map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Add breakpoint at line" })
map("n", "<leader>dus", function()
    local widgets = require("dap.ui.widgets")
    local sidebar = widgets.sidebar(widgets.scopes)
    sidebar.open()
end, { desc = "Open debugging sidebar" })

function MapGo()
    -- dap_go
    map("n", "<leader>dgt", function()
        dap_go.debug_test()
    end, { desc = "Debug go test" })
    map("n", "<leader>dgl", function()
        dap_go.debug_last()
    end, { desc = "Debug last go test" })

    -- gopher
    map("n", "<leader>gsj", "<cmd> GoTagAdd json <CR>", { desc = "Add json struct tags" })
    map("n", "<leader>gsy", "<cmd> GoTagAdd yaml <CR>", { desc = "Add yaml struct tags" })
    map("n", "<leader>gie", "<cmd> GoIfErr <CR>", { desc = "Insert if err != nil boilerplate" })
end

function MapPython()
    -- dap_python
    map("n", "<leader>dpr", function()
        require("dap-python").test_method()
    end, { desc = "Test python method" })
end
