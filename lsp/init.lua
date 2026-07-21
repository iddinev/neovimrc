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

local augroup = vim.api.nvim_create_augroup("LspKeymaps", {})

vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(event)
        local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, {
                buffer = event.buf,
                desc = desc,
            })
        end

        local fzf = require("fzf-lua")

        map("gd", fzf.lsp_definitions, "Definition")
        map("gr", fzf.lsp_references, "References")
        map("gi", fzf.lsp_implementations, "Implementation")
        map("gt", fzf.lsp_typedefs, "Type Definition")

        map("K", vim.lsp.buf.hover, "Hover")
        map("<leader>rn", vim.lsp.buf.rename, "Rename")
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")
    end,
})

local map = vim.keymap.set

map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)
map("n", "<leader>e", vim.diagnostic.open_float)
