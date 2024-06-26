{ pkgs, ... }:

{
  programs.nixvim = {
    extraPlugins = (with pkgs.vimPlugins; [
      actions-preview-nvim
      lazygit-nvim
    ]) ++ [
      (pkgs.vimUtils.buildVimPlugin {
        name = "nvim-material-icon";
        src = pkgs.fetchFromGitHub {
          owner = "DaikyXendo";
          repo = "nvim-material-icon";
          rev = "0fb0e440924e6cf2490542f91672257121026a85";
          hash = "sha256-TEaaP4q3S23Y6Pkcxsic4AObFJmXd88oVxTdyyyhA2c=";
        };
      })
    ];

    extraConfigLua = /* lua */ ''
      vim.filetype.add({
        extension = {
          kusto = 'kusto',
        },
      })

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

      local web_devicons_ok, web_devicons = pcall(require, "nvim-web-devicons")
      if not web_devicons_ok then
        return
      end

      local material_icon_ok, material_icon = pcall(require, "nvim-material-icon")
      if not material_icon_ok then
        return
      end

      material_icon.setup({
        override = {
          ["hcl"] = {
              icon = "󱁢",
              color = "#519aba",
              cterm_color = "67",
              name = "HCL",
          },
        }
      })

      web_devicons.setup({
        override = material_icon.get_icons(),
      })
    '';

    plugins = {
      lualine.enable = true;
      gitsigns.enable = true;
      telescope.enable = true;
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
      lspkind.enable = true;

      markdown-preview = {
        enable = true;
        settings = {
          browser = "brave";
        };
      };

      oil = {
        enable = true;
        settings = {
          experimental_watch_for_changes = true;
          skip_confirm_for_simple_edits = true;
        };
      };

      luasnip = {
        enable = true;
        fromLua = [
          { }
          { paths = ./snippets; }
        ];
      };

      treesitter = {
        enable = true;
        indent = true;
        nixvimInjections = true;
      };

      neoscroll = {
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

          preselect = "cmp.PreselectMode.None";

          sorting.comparators = [
            "require('cmp.config.compare').exact"
            "require('cmp.config.compare').score"
            "require('cmp.config.compare').offset"
            "require('cmp.config.compare').recently_used"
            "require('cmp.config.compare').locality"
            "require('cmp.config.compare').kind"
            "require('cmp.config.compare').length"
            "require('cmp.config.compare').order"
          ];

          sources = [
            { name = "luasnip"; }
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "rg"; }
          ];

          snippet = {
            expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          };

          completion.__raw = "{ completeopt = 'menu,menuone,noinsert' }";
        };
      };

      none-ls = {
        enable = true;
        enableLspFormat = true;

        sources = {
          code_actions = {
            refactoring.enable = true;
            statix.enable = true;
            proselint.enable = true;
          };

          diagnostics = {
            revive.enable = true;
            statix.enable = true;
            proselint.enable = true;
          };

          formatting = {
            gofumpt.enable = true;
            goimports_reviser.enable = true;
            golines.enable = true;
            nixpkgs_fmt.enable = true;
            hclfmt.enable = true;
            # mdformat.enable = true;
          };

          hover = { };
        };
      };

      lsp-format = {
        enable = true;
      };

      lsp = {
        enable = true;
        servers = {
          gopls.enable = true;
          nixd.enable = true;

          lua-ls = {
            enable = true;
          };

          jsonls = {
            enable = true;
          };

          yamlls = {
            enable = true;
          };
        };
      };
    };
  };
}
