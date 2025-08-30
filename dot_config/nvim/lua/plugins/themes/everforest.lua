vim.pack.add({ "https://github.com/neanias/everforest-nvim" })

-- vim.pack.add({ "https://github.com/sainnhe/everforest" })

-- vim.g.everforest_enable_italic = true
-- vim.g.everforest_dim_inactive_windows = true
-- vim.g.everforest_background = "hard"
-- vim.g.everforest_show_eob = false
-- vim.g.everforest_diagnostic_text_highlight = true
-- vim.g.everforest_diagnostic_line_highlight = true
-- vim.g.everforest_diagnostic_virtual_text = "colored"
-- vim.g.everforest_inlay_hints_background = "dimmed"


require("everforest").setup({
  background = "hard",
  italics = true,
  dim_inactive_windows = true,
  diagnostic_text_highlight = true,
  show_eob = false,
})

vim.cmd.colorscheme("everforest")
