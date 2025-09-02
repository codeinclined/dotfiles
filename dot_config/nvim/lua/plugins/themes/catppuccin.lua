vim.pack.add({ {
  src = "https://github.com/catppuccin/nvim",
  name = "catppuccin",
} })

require("catppuccin").setup({
  flavour = "macchiato",
  dim_inactive = { enabled = true, },
  integrations = {
    snacks = {
      enabled = true,
    },
  }
})

vim.cmd.colorscheme("catppuccin")
