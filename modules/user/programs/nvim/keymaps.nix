{ ... }:

{
  programs.nixvim.keymapsOnEvents = {
    LspAttach = [
      {
        action = "require('telescope.builtin').lsp_definitions";
        key = "gd";
        lua = true;
        options.desc = "[G]oto [D]efinition";
      }
      {
        action = "require('telescope.builtin').lsp_references";
        key = "gr";
        lua = true;
        options.desc = "[G]oto [R]eference";
      }
      {
        action = "require('telescope.builtin').lsp_implementations";
        key = "gI";
        lua = true;
        options.desc = "[G]oto [I]mplementations";
      }
      {
        action = "require('telescope.builtin').lsp_document_symbols";
        key = "<leader>ds";
        lua = true;
        options.desc = "[D]ocument [S]ymbols";
      }
      {
        action = "require('telescope.builtin').lsp_workspace_symbols";
        key = "<leader>ws";
        lua = true;
        options.desc = "[W]orkspace [S]ymbols";
      }
      {
        action = "vim.lsp.buf.rename";
        key = "<leader>sr";
        lua = true;
        options.desc = "[S]ymbol [R]ename";
      }
      {
        action = "vim.lsp.buf.code_action";
        key = "<leader>ca";
        lua = true;
        options.desc = "[C]ode [A]ction";
      }
      {
        action = "vim.lsp.buf.hover";
        key = "K";
        lua = true;
        options.desc = "Hover Documentation";
      }
      {
        action = "vim.lsp.buf.declaration";
        key = "gD";
        lua = true;
        options.desc = "[G]oto [D]eclaration";
      }
    ];
  };
}
