{ ... }:

{
  programs.nixvim.autoGroups = {
    lsp_attach = { clear = true; };
  };

  programs.nixvim.autoCmd = [
    {
      event = [ "LspAttach" ];
      group = "lsp_attach";
      callback.__raw = ''
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
  ];
}
