vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main", }
})

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

vim.treesitter.query.add_directive("inject-go-tmpl!", function(_, _, bufnr, _, metadata)
  local path = vim.api.nvim_buf_get_name(bufnr) ---@diagnostic disable-line
  local fname = vim.fs.basename(path)

  -- Chezmoi paths substitute dotfiles with a dot_ prefix so change it back to detect
  -- things like .gitconfig which do not have an extension
  if string.find(path, ".local/share/chezmoi", 1, true) then
    fname, _ = string.gsub(fname, "^dot_", ".")
  end

  local _, _, ext, _ = string.find(fname, ".*%.(%a+)(%.%a+)")

  if ext then
    metadata["injection.language"] = ext
  end
end, {})

vim.filetype.add({
  extension = {
    tmpl = "gotmpl",
  },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = ts.get_installed(),
  callback = function() vim.treesitter.start() end,
})

