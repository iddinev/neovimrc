local map = vim.keymap.set

-- FUNCTIONS
local function toggle_diff()
    local view = vim.fn.winsaveview()

    if vim.wo.diff then
        vim.cmd("diffoff!")
    else
        vim.cmd("windo diffthis")
    end

    vim.fn.winrestview(view)
end

local function toggle_wrap()
    vim.wo.wrap = not vim.wo.wrap
    print("wrap:", vim.wo.wrap)
end

local function toggle_search_highlighting()
    vim.opt.hlsearch = not vim.opt.hlsearch:get()
end

-- WINDOWS
map("n", "J", "<C-w>j")
map("n", "K", "<C-w>k")
map("n", "L", "<C-w>l")
map("n", "H", "<C-w>h")

-- TABS
map("n", "<C-h>", "<Cmd>tabprevious<CR>", { silent = true })
map("n", "<C-l>", "<Cmd>tabnext<CR>", { silent = true })

-- MISC
map("n", "Q", "<Nop>")
map("n", "<F4>", toggle_search_highlighting, { desc = "Toggle search highlighting" })
map("n", "<F6>", toggle_diff, { desc = "Toggle diff mode" })
map("n", "<F8>", toggle_wrap, { desc = "Toggle line wrapping" })
