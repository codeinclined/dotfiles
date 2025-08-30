vim.pack.add({{
  src = "https://github.com/Saghen/blink.cmp",
  version = "v1.6.0",
}})

require("blink.cmp").setup({
  keymap = { preset = "default", },
  completion = { documentation = { auto_show = false, }, },
  sources = {
    default = { "lsp", "path" },
  },

  fuzzy = { implementation = "prefer_rust_with_warning", },
})

