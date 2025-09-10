local micons = require("mini.icons")

---@param path string
---@return string
local shorten_path = function(path)
  local home_path = vim.uv.os_homedir()
  if string.sub(path, 1, #home_path) == home_path then
    return "~" .. string.sub(path, #home_path + 1)
  end

  return path
end

local ft_to_icon_map = {
  [""] = "",
}

local ft_to_name_map = {
  oil = function() return shorten_path(require("oil").get_current_dir()) end,
}

local osc_state = {
  title = {
    ft = "",
    filename = "",
    modified = false,

    get_icon = function(self)
      if ft_to_icon_map[self.ft] ~= nil then
        return ft_to_icon_map[self.ft]
      end

      return micons.get("filetype", self.ft) .. " "
    end,

    get_name = function(self)
      if ft_to_name_map[self.ft] ~= nil then
        return ft_to_name_map[self.ft]()
      end

      return self.filename
    end,

    get_modified = function(self)
      if self.modified then
        return " 󰛄"
      end

      return ""
    end
  },

  refresh = function(self)
    vim.o.title = true
    vim.o.titlestring = " " .. self.title:get_icon() .. self.title:get_name() .. self.title:get_modified()
  end
}

local osc_group = vim.api.nvim_create_augroup('after_osc', { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufFilePost", "FileType" }, {
  pattern = "*",
  group = osc_group,
  callback = function(args)
    -- Don't change the title on floating windows
    local win = vim.api.nvim_get_current_win()
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      return
    end

    osc_state.title.filename = vim.fs.basename(args.file)
    osc_state.title.ft = vim.bo.filetype
    osc_state:refresh()
  end
})

vim.api.nvim_create_autocmd({ "BufModifiedSet" }, {
  pattern = "*",
  group = osc_group,
  callback = function()
    if osc_state.title.modified ~= vim.bo.modified then
      osc_state.title.modified = vim.bo.modified
      osc_state:refresh()
    end
  end,
})
