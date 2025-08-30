vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

require("oil").setup({})

vim.keymap.set("n", "-", require("oil").open, { desc = "Oil: Open, buffer directory" })
