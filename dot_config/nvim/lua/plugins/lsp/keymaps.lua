vim.keymap.set("n", "<leader>dn", function() vim.diagnostic.jump({ count = 1, float=true, }) end, { desc = "Diagnostic, next", })
vim.keymap.set("n", "<leader>dp", function() vim.diagnostic.jump({ count = -1, float=true, }) end, { desc = "Diagnostic, previous", })

vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, { desc = "LSP, rename", })
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "LSP, format", })

