vim.lsp.config("*", {
    root_markers = {
        ".git",
    },
})

vim.o.winborder = "rounded"

vim.diagnostic.config({
    virtual_text = false,
    underline = true,
    signs = true,
    severity_sort = true,
    update_in_insert = false,

    float = {
        border = "rounded",
        source = "if_many",
    },
})

require("lsp.keymaps")
