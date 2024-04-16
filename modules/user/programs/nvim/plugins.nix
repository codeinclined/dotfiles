{ pkgs, ... }:

{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      actions-preview-nvim
    ];

    extraConfigLua = ''
      require("actions-preview").setup {
        telescope = {
          sorting_strategy = "ascending",
          layout_strategy = "vertical",
          layout_config = {
            width = 0.8,
            height = 0.9,
            prompt_position = "top",
            preview_cutoff = 20,
            preview_height = function(_, _, max_lines)
              return max_lines - 15
            end,
          }
        }
      }
    '';

    plugins = {
      lualine.enable = true;
      gitsigns.enable = true;
      telescope.enable = true;
      oil.enable = true;
      luasnip.enable = true;
      dap.enable = true;
      fidget.enable = true;
      sleuth.enable = true;
      comment.enable = true;
      trouble.enable = true;
      diffview.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp_luasnip.enable = true;
      cmp-rg.enable = true;
      rainbow-delimiters.enable = true;
      undotree.enable = true;

      treesitter = {
        enable = true;
        indent = true;
        nixvimInjections = true;
      };

      neoscroll = {
        enable = true;
      };

      neogit = {
        enable = true;
      };

      nvim-autopairs = {
        enable = true;
      };

      notify = {
        enable = true;
      };

      noice = {
        enable = true;
        lsp = {
            override = {
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
              "vim.lsp.util.stylize_markdown" = true;
              "cmp.entry.get_documentation" = true;
            };
        };

        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = false;
          lsp_doc_border = false;
        };
      };

      flash = {
        enable = true;
      };

      indent-blankline = {
        enable = true;
      };

      which-key = {
        enable = true;
      };

      spider = {
        enable = true;
        keymaps.motions = {
          b = "b";
          e = "e";
          ge = "ge";
          w = "w";
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;

        settings = {
          mapping.__raw = ''
            cmp.mapping.preset.insert({
              ['<C-n>'] = cmp.mapping.select_next_item(),
              ['<C-p>'] = cmp.mapping.select_prev_item(),

              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),

              ['<C-y>'] = cmp.mapping.confirm { select = true },
              ['<C-Space>'] = cmp.mapping.complete {},

              ['<C-l>'] = cmp.mapping(function()
                local luasnip = require("luasnip")

                if luasnip.expand_or_locally_jumpable() then
                    luasnip.expand_or_jump()
                end
              end, { 'i', 's' }),

              ['<C-h>'] = cmp.mapping(function()
                local luasnip = require("luasnip")

                if luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                end
              end, { 'i', 's' }),
            })
          '';

          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "rg"; }
          ];

          snippet = {
            expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          };

          completion.__raw = "{ completeopt = 'menu,menuone,noinsert' }";
        };
      };

      efmls-configs = {
        enable = true;
        # externallyManagedPackages = [ "terraform" ];
        setup = {
          go = {
            formatter = [ "gofumpt" "golines" "goimports" ];
            linter = "go_revive";
          };

          nix = {
            formatter = "nixfmt";
            linter = "statix";
          };

          /* terraform = {
            formatter = "terraform_fmt";
          }; */
        };
      };

      lsp-format = {
        enable = true;
        setup = {
          gopls = {
            exclude = [ "gopls" ];
            force = true;
            order = [ "gopls" "efm" ];
            sync = true;
          };
        };
      };

      lsp = {
        enable = true;
        servers = { 
          lua-ls.enable = true;
          gopls.enable = true;
          nixd.enable = true;
          efm.enable = true;
        };
      };
    };
  };
}
