local wezterm = require('wezterm')
local config = {}

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("CommitMono Nerd Font")
config.font_size = 14.0

-- config.wsl_domains = {
--   {
--     name = "WSL:NixOS",
--     distribution = "NixOS",
--     username = "jtaylor",
--     default_cwd = "/home/jtaylor",
--   },
-- }
-- config.default_domain = "WSL:NixOS"

config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.tab_max_width = 64

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

config.front_end = "WebGpu"
config.animation_fps = 72
config.default_cursor_style = "BlinkingBlock"

config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 150,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 150,
}
config.colors = {
  visual_bell = '#0b1b2f',
}

config.enable_scroll_bar = false
config.window_padding = {
  left = "7px",
  right = "7px",
  top = "7px",
  bottom = 0
}

config.term = "wezterm"

local function basename(s)
  return string.gsub(tostring(s), '(.*[/\\])(.*)', '%2')
end

local prog_table = {
  [""] = '',
  less = "",
  nvim = "",
  bat = "󰄛",
  cat = "󰄛",
  c = "󰄛",
  terragrunt = "󱁢",
  terraform = "󱁢",
  lazygit = "",
  k9s = "󰠳",
  ["nixos-rebuild"] = "󱄅",
  ["home-manager"] = "󱄅",
}

local tab_sec = ' ⏐ '

local function translate_prog(user_vars, _, fg_color)
  local prog = tostring(user_vars.WEZTERM_PROG)
  local nvim_buffer = tostring(user_vars.NVIM_BUF)
  local translatedProg = ''

  if string.len(prog) < 1 then
    translatedProg = prog_table[""] .. tab_sec
  else
    for chunk in string.gmatch(prog, '[^|&]+') do
      local trimmed = string.gsub(chunk, '^%s*(.-)%s$', '%1')
      local nixShell = false
      for command in string.gmatch(trimmed, '[^%s]+') do
        if not nixShell then
          if command == 'sudo' then
            translatedProg = translatedProg .. '󱐋 '
          elseif command == 'nix-shell' then
            translatedProg = translatedProg .. '󱄅 '
            nixShell = true
          elseif command == 'nvim' then
            if string.len(nvim_buffer) > 0 then
              local buf_tokens = string.gmatch(nvim_buffer, '[^;]+')
              local color_str = buf_tokens() or ''
              local type_str = buf_tokens() or ''
              local file_str = buf_tokens() or ''
              for additional_token in buf_tokens do
                file_str = file_str .. ';' .. additional_token
              end

              return {
                { Foreground = { Color = "#67b15e" } },
                { Text = prog_table[command] .. '  ' },
                { Foreground = { Color = color_str } },
                { Text = type_str },
                { Foreground = { Color = fg_color } },
                { Text = ' ' .. file_str .. tab_sec }
              }
            end

            translatedProg = translatedProg ..
                prog_table[command] .. '  ' .. '(unk)' .. tab_sec
            break
          else
            translatedProg = translatedProg .. (prog_table[command] or command) .. tab_sec
            break
          end
        end

        if nixShell and command == '--run' then
          nixShell = false
        end
      end
    end
  end

  return {
    { Foreground = { Color = fg_color } },
    { Text = translatedProg },
  }
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local user = pane.user_vars.WEZTERM_USER

  local bg_color = "#181825"
  if tab.is_active then
    bg_color = "#313244"
  elseif hover then
    bg_color = "#4c4e6a"
  end

  local fg_color = "#ffffff"
  if tab.is_active then
    fg_color = "#ffffff"
  elseif hover then
    fg_color = "#ffffff"
  end

  local translatedProg = translate_prog(pane.user_vars, bg_color, fg_color)
  local translatedUser = (user == 'root') and '󱐋 ' or ''

  local tab_fmt = {
    { Background = { Color = bg_color } },
    { Foreground = { Color = fg_color } },
    { Text = '  󰄷 ' },
    { Text = translatedUser },
    { Text = '(' .. (tab.tab_index + 1) },
    { Text = ((string.len(tab.tab_title) > 0) and (': ' .. tab.tab_title .. ')' .. tab_sec) or ')' .. tab_sec) },
  }

  for _, v in pairs(translatedProg) do
    table.insert(tab_fmt, v)
  end

  table.insert(tab_fmt, { Text = ('󰙅 ' .. basename(pane.current_working_dir) .. ' ') })

  return tab_fmt

  -- return '  󰄷 ' .. translatedUser ..
  --     '(' .. (tab.tab_index + 1) ..
  --     ((string.len(tab.tab_title) > 0) and (': ' .. tab.tab_title .. ')' .. tab_sec) or ')' .. tab_sec) ..
  --     translatedProg ..
  --     '󰙅 ' .. basename(pane.current_working_dir) ..
  --     '  '
end)

config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'CTRL',
    action = wezterm.action.IncreaseFontSize,
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'CTRL',
    action = wezterm.action.DecreaseFontSize,
  },
}

config.disable_default_key_bindings = true

local act = wezterm.action
local resize_step = 1
local large_resize_step = 5

config.key_tables = {
  resize_pane = {
    { key = 'n',      action = act.AdjustPaneSize { 'Left', resize_step } },
    { key = 'e',      action = act.AdjustPaneSize { 'Down', resize_step } },
    { key = 'i',      action = act.AdjustPaneSize { 'Up', resize_step } },
    { key = 'o',      action = act.AdjustPaneSize { 'Right', resize_step } },

    { key = 'N',      action = act.AdjustPaneSize { 'Left', large_resize_step } },
    { key = 'E',      action = act.AdjustPaneSize { 'Down', large_resize_step } },
    { key = 'I',      action = act.AdjustPaneSize { 'Up', large_resize_step } },
    { key = 'O',      action = act.AdjustPaneSize { 'Right', large_resize_step } },

    { key = 'Escape', action = act.PopKeyTable },
  },
}

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2500 }
config.keys = {
  -- WINDOWS --
  { key = 'f', mods = 'LEADER',      action = act.ToggleFullScreen },

  -- PANES --
  { key = 'r', mods = 'LEADER',      action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false } },

  { key = 'n', mods = 'LEADER',      action = act.ActivatePaneDirection 'Left' },
  { key = 'e', mods = 'LEADER',      action = act.ActivatePaneDirection 'Down' },
  { key = 'i', mods = 'LEADER',      action = act.ActivatePaneDirection 'Up' },
  { key = 'o', mods = 'LEADER',      action = act.ActivatePaneDirection 'Right' },

  { key = 'n', mods = 'LEADER|CTRL', action = act.SplitPane { direction = 'Left', command = { domain = 'CurrentPaneDomain' } } },
  { key = 'e', mods = 'LEADER|CTRL', action = act.SplitPane { direction = 'Down', command = { domain = 'CurrentPaneDomain' } } },
  { key = 'i', mods = 'LEADER|CTRL', action = act.SplitPane { direction = 'Up', command = { domain = 'CurrentPaneDomain' } } },
  { key = 'o', mods = 'LEADER|CTRL', action = act.SplitPane { direction = 'Right', command = { domain = 'CurrentPaneDomain' } } },

  { key = 'x', mods = 'LEADER',      action = act.CloseCurrentPane { confirm = true } },

  -- TABS --
  { key = 't', mods = 'LEADER',      action = act.ActivateLastTab },

  { key = ')', mods = 'LEADER',      action = act.ActivateTabRelative(-1) },
  { key = "'", mods = 'LEADER',      action = act.ActivateTabRelative(1) },

  { key = 't', mods = 'LEADER|CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'x', mods = 'LEADER|CTRL', action = act.CloseCurrentTab { confirm = true } },

  -- Rename tab --
  {
    key = 't',
    mods = 'LEADER|ALT',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }
  },

  -- CLIPBOARD --
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },
}

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1)
  })
end

return config
