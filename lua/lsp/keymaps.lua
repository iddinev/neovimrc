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

map("n", "<C-d>", function()
    if not vim.lsp.util.scroll_preview(4) then
        return "<C-d>"
    end
end, { expr = true })

map("n", "<C-u>", function()
    if not vim.lsp.util.scroll_preview(-4) then
        return "<C-u>"
    end
end, { expr = true })
