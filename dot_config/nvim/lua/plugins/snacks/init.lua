vim.pack.add({ "https://github.com/folke/snacks.nvim" })
local snacks = require("snacks")
local picker = snacks.picker

snacks.setup({
  indent = { enabled = true, },
  picker = { enabled = true, },
})

-- Terminal
vim.keymap.set("n", "<leader>tt", function() snacks.terminal.toggle({"nu", "-i"}) end, { desc = "Terminal, floating", })

-- Lazygit
vim.keymap.set("n", "<leader>gl", function() snacks.lazygit() end, { desc = "Lazygit, current repo", })

-- Pickers
vim.keymap.set("n", "<leader>pp", picker.pickers, { desc = "Pick, pickers", })
vim.keymap.set("n", "<leader>pr", picker.resume, { desc = "Pick, pickers", })
vim.keymap.set("n", "<leader>ps", picker.smart, { desc = "Pick, smart", })
vim.keymap.set("n", "<leader>pf", picker.files, { desc = "Pick, files", })
vim.keymap.set("n", "<leader>pb", picker.buffers, { desc = "Pick, buffers", })
vim.keymap.set("n", "<leader>pd", picker.diagnostics, { desc = "Pick, diagnostics", })
vim.keymap.set("n", "<leader>pvb", picker.git_branches, { desc = "Pick, git branches", })
vim.keymap.set("n", "<leader>pg", picker.grep, { desc = "Pick, grep", })
vim.keymap.set("n", "<leader>pi", picker.icons, { desc = "Pick, icons", })

