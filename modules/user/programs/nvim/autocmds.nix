{ ... }:

{
  programs.nixvim.autoGroups = {
    lsp_attach = { clear = true; };
    wezterm_buf_enter = { clear = true; };
  };

  programs.nixvim.autoCmd = [
    {
      event = [ "LspAttach" ];
      group = "lsp_attach";
      callback.__raw = /* lua */ ''
        function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end
      '';
    }

    {
      event = [ "BufEnter" ];
      group = "wezterm_buf_enter";
      callback.__raw = /* lua */ ''
        function()
          -- http://lua-users.org/wiki/BaseSixtyFour
          local dic = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
          local encode_b64 = function(data)
            return (
              (data:gsub('.', function(x)
                local r, b = "", x:byte()
                for i = 8, 1, -1 do
                  r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0')
                end
                return r
              end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
                if #x < 6 then
                  return ""
                end
                local c = 0
                for i = 1, 6 do
                  c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0)
                end
                return dic:sub(c + 1, c + 1)
              end) .. ({ "", '==', '=' })[#data % 3 + 1]
            )
          end

          local filename = string.match(tostring(vim.api.nvim_buf_get_name(0)), '[^/\\]+$')
          if filename == nil then
            local buf_type = 'scratch'

            local oil_dir = require('oil').get_current_dir()
            oil_dir = string.match(tostring(oil_dir), '[^/\\]+/$')
            buf_type = oil_dir and 'oil' or buf_type

            local buf_symbols = {
              oil = ' ' .. tostring(oil_dir),
              scratch = '󰛄',
            }

            filename = (buf_symbols[buf_type] or '')
          else
            filename = ' ' .. filename
          end

          io.write('\x1b]1337;SetUserVar=NVIM_BUF=' .. encode_b64(filename) .. '\x07')
        end
      '';
    }
  ];
}
