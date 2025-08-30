vim.pack.add({{
  src = "https://github.com/everviolet/nvim",
  name = "evergarden",
}})

require("evergarden").setup({
  theme = {
    variant = "fall",
    accent = "green",
  },
})

vim.cmd.colorscheme("evergarden")
