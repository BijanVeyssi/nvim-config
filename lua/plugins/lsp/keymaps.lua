local M = {}

function M.on_attach(bufnr)
    local telescope = require("utils").telescope

    local function map(key, rhs, desc)
        vim.keymap.set("n", key, rhs, {
            silent = true,
            buffer = bufnr,
            desc = desc,
        })
    end

    map("K", vim.lsp.buf.hover, "")

    map("<leader>lD", vim.lsp.buf.declaration, "declaration")
    map("<leader>ld", telescope("lsp_definitions"), "definition")
    map("<leader>li", telescope("lsp_implementations"), "implementation")
    map("<leader>lt", telescope("lsp_type_definitions"), "type defintion")
    map("<leader>lr", telescope("lsp_references"), "references")
    map("<leader>ly", telescope("lsp_document_symbols"), "LSP symbols")

    map("<leader>ln", vim.lsp.buf.rename, "rename")
    map("<leader>la", vim.lsp.buf.code_action, "action")
    vim.keymap.set("x", "gla", vim.lsp.buf.code_action, {
        silent = true,
        buffer = bufnr,
        desc = "action",
    })

    map("<leader>ll", vim.diagnostic.goto_prev, "previous diagnostic")
    map("<leader>lk", vim.diagnostic.goto_next, "next diagnostic")
    map("<leader>lf", telescope("diagnostics"), "diagnostics list")
    map("<leader>ls", function()
        vim.diagnostic.open_float({ scope = "cursor" })
    end, "cursor diagnostic")
    map("<leader>lS", function()
        vim.diagnostic.open_float({ scope = "line" })
    end, "line diagnostics")
end

return M
