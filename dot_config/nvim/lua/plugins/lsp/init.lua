vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })
require("plugins.lsp.keymaps")

vim.lsp.enable("zls")
vim.lsp.enable("bashls")
vim.lsp.enable("gopls")
vim.lsp.enable("nushell")

require("plugins.lsp.pylsp")
vim.lsp.enable("pylsp")

require("plugins.lsp.yamlls")
vim.lsp.enable("yamlls")

require("plugins.lsp.lua_ls")
vim.lsp.enable("lua_ls")

require("plugins.lsp.rust_analyzer")
vim.lsp.enable("rust_analyzer")
