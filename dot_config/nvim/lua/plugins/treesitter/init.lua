vim.pack.add({{
  src = "https://github.com/nvim-treesitter/nvim-treesitter",
  version = "main",
}})

local ts = require("nvim-treesitter")

local ts_update_group = vim.api.nvim_create_augroup("TreesitterUpdate", { clear = true, })

vim.api.nvim_create_autocmd("PackChanged", {
  group = ts_update_group,
  pattern = "*",
  callback = function(ev)
    if ev.data.spec and ev.data.spec.name == "nvim-treesitter" and ev.data.kind ~= "deleted" then
      vim.cmd("TSUpdate")
    end
  end,
})

ts.install(
  require("plugins.treesitter.parsers")
):wait(300000)

vim.api.nvim_create_autocmd('FileType', {
    pattern = ts.get_installed(),
    callback = function() vim.treesitter.start() end,
})
