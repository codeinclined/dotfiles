vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      assist = {
        preferSelf = true,
      },

      diagnostics = {
        styleLints = { enable = true, },
      },
    },
  },
})
