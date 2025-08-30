vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemas = {
        ["https://taskfile.dev/schema.json"] = "/**/Taskfile.yml"
      }
    },
  },
})
