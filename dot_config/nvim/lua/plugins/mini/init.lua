vim.pack.add({ "https://github.com/echasnovski/mini.nvim" })

local m_icons = require("mini.icons")
m_icons.setup({})
m_icons.mock_nvim_web_devicons()

local m_diff = require("mini.diff")
m_diff.setup({})

local m_git = require("mini.git")
m_git.setup({})

local m_statusline = require("mini.statusline")
m_statusline.setup({})
