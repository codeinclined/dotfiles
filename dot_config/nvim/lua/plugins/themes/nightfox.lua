vim.pack.add({ "https://github.com/EdenEast/nightfox.nvim" })

require("nightfox").setup({
  dim_inactive = true,
})

vim.cmd.colorscheme("terafox")
