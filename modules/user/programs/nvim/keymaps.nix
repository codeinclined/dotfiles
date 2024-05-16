{ lib, ... }:

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
    action = /* lua */ "function() require('telescope.builtin').find_files { cwd = vim.fn.expand('${path}') } end";
    lua = true;
    mode = "n";
    options.desc = desc;
  };

  mkMenuKeymap = mode: key: desc: luaAction: {
    inherit mode key;
    options.desc = desc;
    lua = true;
    action = /* lua */ ''
      function()
        local Menu = require("nui.menu")
        local callback = ${luaAction}

        local menu = Menu({
          position = "50%",
          size = {
            width = 25,
            height = 4,
          },
          border = {
            style = "single", 
            text = {
              top = "[ Query which cloud? ]",
              top_align = "center",
            },
          },
          win_options = {
            winhighlight = "Normal:Normal,FloatBorder:Normal",
          },
        }, {
          lines = {
            Menu.item("Current"),
            Menu.separator("Specific", { char = "-", text_align = "right", }),
            Menu.item("AzureCloud"),
            Menu.item("AzureChinaCloud"),
          },
          max_width = 20,
          keymap = {
            focus_next = { "j", "<Down>", "<Tab>" },
            focus_prev = { "k", "<Up>", "<S-Tab>" },
            close = { "<Esc>", "<C-c>" },
            submit = { "<CR>", "<Space>" },
          },
          on_submit = callback,
        })

        menu:mount()
      end
    '';
  };

  mkPopupShellOutputKeymap = key: commandList: desc: {
    inherit key;
    lua = true;
    options.desc = desc;
    action = /* lua */ ''
      function()
        local Popup = require("nui.popup")
        local Layout = require("nui.layout")
        
        local stdOutPopup = Popup({
          enter = true,
          focusable = true,
          border = "single",
        })
        local stdErrPopup = Popup({
          focusable = true,
          border = "single",
        })
        local summaryPopup = Popup({
          focusable = true,
          border = "single",
        })

        local layout = Layout(
          {
            position = "50%",
            size = {
              width = "80%",
              height = "80%",
            },
          },
          Layout.Box({
            Layout.Box(stdOutPopup, { size = "40%" }),
            Layout.Box(stdErrPopup, { size = "40%" }),
            Layout.Box(summaryPopup, { size = "20%" }),
          }, { dir = "col" })
        )

        layout:mount()

        stdOutPopup:map("n", "q", function() layout:unmount() end)
        stdErrPopup:map("n", "q", function() layout:unmount() end)
        summaryPopup:map("n", "q", function() layout:unmount() end)

        vim.api.nvim_buf_set_lines(summaryPopup.bufnr, 0, 0, false, { "Waiting on command..." })

        local on_exit = function(obj)
          local output_text = ' '
          if (obj.stdout == nil or string.len(obj.stdout) < 1) then
            output_text = '<stdout empty>'
          else
            output_text = obj.stdout
          end

          local error_text = ' '
          if (obj.stderr == nil or string.len(obj.stderr) < 1) then
            error_text = '<stderr empty>'
          else
            error_text = obj.stderr
          end

          vim.api.nvim_buf_set_lines(stdOutPopup.bufnr, 0, 1, false, { output_text })
          vim.api.nvim_buf_set_lines(stdErrPopup.bufnr, 0, 1, false, { error_text })
          vim.api.nvim_buf_set_lines(summaryPopup.bufnr, 0, 1, false, { "Execution finished with code: " .. obj.code })
        end

        vim.system({"${lib.strings.concatStringsSep "\", \"" commandList}"}, { text = true }, vim.schedule_wrap(on_exit))
      end
    '';
  };

  mkLuaSnipChoiceNav = key: delta: {
    inherit key;

    mode = [ "i" "s" ];
    lua = true;
    action = /* lua */ ''
      function()
        local ls = require('luasnip')
        if ls.choice_active() then
          ls.change_choice(${delta})
        end
      end
    '';
  };

in
{
  programs.nixvim.keymaps = [
    (mkTelescopeKeymap "<leader>sh" "help_tags" "[S]earch [H]elp")
    (mkTelescopeKeymap "<leader>sk" "keymaps" "[S]earch [K]eymaps")
    (mkTelescopeKeymap "<leader>sf" "find_files" "[S]earch [F]iles")
    (mkTelescopeKeymap "<leader>ss" "builtin" "[S]earch [S]elect Telescope")
    (mkTelescopeKeymap "<leader>sw" "grep_string" "[S]earch current [W]ord")
    (mkTelescopeKeymap "<leader>sg" "live_grep" "[S]earch by [G]rep")
    (mkTelescopeKeymap "<leader>sd" "diagnostics" "[S]earch [D]iagnostics")
    (mkTelescopeKeymap "<leader>sr" "resume" "[S]earch [R]esume")
    (mkTelescopeKeymap "<leader>s." "oldfiles" "[S]earch Recent Files")
    (mkTelescopeKeymap "<leader>sb" "buffers" "[S]earch existing [B]uffers")

    (mkTelescopePathKeymap "<leader>spn" "$HOME/dotfiles" "[S]earch [P]ath: [N]ix")
    (mkTelescopePathKeymap "<leader>sps" "$HOME/src" "[S]earch [P]ath: [S]ource files")
    (mkTelescopePathKeymap "<leader>spb" "$HOME/bitbucket" "[S]earch [P]ath: [B]itbucket")
    (mkTelescopePathKeymap "<leader>spc" "$HOME/bitbucket" "[S]earch [P]ath: s[C]ratch")

    (mkPopupShellOutputKeymap "<leader>lgt" [ "go" "mod" "tidy" ] "Run 'go mod tidy' in an NUI floating window")

    { mode = [ "i" "s" ]; key = "<M-n>"; lua = true; action = /* lua */ "function() require('luasnip').jump(-1) end"; }
    { mode = [ "i" "s" ]; key = "<M-o>"; lua = true; action = /* lua */ "function() require('luasnip').jump(1) end"; }
    (mkLuaSnipChoiceNav "<M-e>" "1")
    (mkLuaSnipChoiceNav "<M-i>" "-1")

    { mode = "n"; key = "<leader>t"; action = "<cmd>Trouble<CR>"; }
    { mode = "n"; key = "<leader>-"; action = "<cmd>Oil<CR>"; }
    { mode = "n"; key = "<leader>g"; action = "<cmd>LazyGit<CR>"; }

    (mkMenuKeymap "n" "<leader>zg" "Azure Resource Graph query with current buffer" /* lua */ ''
      function(item)
        local cloud_name = item.text
        local Job = require("plenary.job")
        local buf_text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")

        local tempname = os.tmpname()
        local tempfile = io.open(tempname, "w")
        tempfile:write(buf_text)
        tempfile:close()

        local complete_result = {}

        local set_result = function()
          if type(ArmGraphResultBuf) == "nil" then 
            ArmGraphResultBuf = vim.api.nvim_create_buf(true, true)
            vim.api.nvim_buf_set_name(ArmGraphResultBuf, "graph results")
            vim.api.nvim_set_option_value("filetype", "json", { buf = ArmGraphResultBuf })
            vim.api.nvim_command(string.format("vsplit | b %d", ArmGraphResultBuf))
          end

          vim.api.nvim_buf_set_lines(ArmGraphResultBuf, 0, -1, true, complete_result)
        end

        Job:new({
          command = "/home/jtaylor/scratch/hacking/run_graph_query.bash",
          args = { cloud_name, tempname },
          on_stderr = function(_, data) vim.notify(data) end,
          on_stdout = function(_, data) table.insert(complete_result, data) end,
          on_exit = vim.schedule_wrap(set_result),
        }):start()
      end
    '')
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
        key = "<leader>csd";
        lua = true;
        options.desc = "[D]ocument [S]ymbols";
      }
      {
        action = "require('telescope.builtin').lsp_workspace_symbols";
        key = "<leader>csw";
        lua = true;
        options.desc = "[W]orkspace [S]ymbols";
      }
      {
        action = "vim.lsp.buf.rename";
        key = "<leader>cr";
        lua = true;
        options.desc = "[S]ymbol [R]ename";
      }
      {
        action = "require('actions-preview').code_actions";
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
