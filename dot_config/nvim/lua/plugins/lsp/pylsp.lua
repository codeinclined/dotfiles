vim.lsp.config("pylsp", {
  settings = {
    pylsp = {
      plugins = {
        ignore = {"W391"},
        maxLineLength = 120,
      },
    },
  },
})
