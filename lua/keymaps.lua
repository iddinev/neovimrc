local map = vim.keymap.set

-- Window navigation
map("n", "J", "<C-w>j")
map("n", "K", "<C-w>k")
map("n", "L", "<C-w>l")
map("n", "H", "<C-w>h")

-- Tab navigation
map("n", "<C-h>", "<Cmd>tabprevious<CR>", { silent = true })
map("n", "<C-l>", "<Cmd>tabnext<CR>", { silent = true })
