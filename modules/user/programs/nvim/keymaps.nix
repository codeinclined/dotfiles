_:

let

  mkTelescopeKeymap = key: builtinAction: desc: {
    inherit key;
    action = "require('telescope.builtin')." + builtinAction;
    lua = true;
    mode = "n";
    options.desc = desc;
  };

  mkTelescopePathKeymap = key: path: desc: {
    inherit key;
    action = "function() require('telescope.builtin').find_files { cwd = vim.fn.expand('${path}') } end";
    lua = true;
    mode = "n";
    options.desc = desc;
  };

in {
  programs.nixvim.keymaps = [
    (mkTelescopeKeymap "<leader>sh" "help_tags"   "[S]earch [H]elp")
    (mkTelescopeKeymap "<leader>sk" "keymaps"     "[S]earch [K]eymaps")
    (mkTelescopeKeymap "<leader>sf" "find_files"  "[S]earch [F]iles")
    (mkTelescopeKeymap "<leader>ss" "builtin"     "[S]earch [S]elect Telescope")
    (mkTelescopeKeymap "<leader>sw" "grep_string" "[S]earch current [W]ord")
    (mkTelescopeKeymap "<leader>sg" "live_grep"   "[S]earch by [G]rep")
    (mkTelescopeKeymap "<leader>sd" "diagnostics" "[S]earch [D]iagnostics")
    (mkTelescopeKeymap "<leader>sr" "resume"      "[S]earch [R]esume")
    (mkTelescopeKeymap "<leader>s." "oldfiles"    "[S]earch Recent Files")
    (mkTelescopeKeymap "<leader>sb" "buffers"     "[S]earch existing [B]uffers")

    (mkTelescopePathKeymap "<leader>spn" "$HOME/dotfiles"  "[S]earch [P]ath: [N]ix")
    (mkTelescopePathKeymap "<leader>sps" "$HOME/src"       "[S]earch [P]ath: [S]ource files")
    (mkTelescopePathKeymap "<leader>spb" "$HOME/bitbucket" "[S]earch [P]ath: [B]itbucket")
    (mkTelescopePathKeymap "<leader>spc" "$HOME/bitbucket" "[S]earch [P]ath: s[C]ratch")

    { mode = "n"; key = "<leader>t"; action = "<cmd>Trouble<CR>"; }
    { mode = "n"; key = "<leader>-"; action = "<cmd>Oil<CR>"; }
    { mode = "n"; key = "<leader>g"; action = "<cmd>Neogit<CR>"; }
  ];

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
