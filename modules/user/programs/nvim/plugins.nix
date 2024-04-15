{ ... }:

{
  programs.nixvim.plugins = {
    lualine.enable = true;
    gitsigns.enable = true;
    telescope.enable = true;
    oil.enable = true;
    treesitter.enable = true;
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

    neoscroll = {
      enable = true;
    };

    nvim-autopairs = {
      enable = true;
    };

    noice = {
      enable = true;
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

    lsp = {
      enable = true;
      servers = { 
        lua-ls.enable = true;
        gopls.enable = true;
        nixd.enable = true;
      };
    };
  };
}
