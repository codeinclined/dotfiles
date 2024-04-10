{ ... }:

{
  programs.nixvim.colorschemes.catppuccin = {
    enable = true;
    flavour = "macchiato";
    terminalColors = true;

    integrations = {
      aerial = true;
      cmp = true;
      dap.enabled = true;
      fidget = true;
      gitsigns = true;
      indent_blankline.enabled = true;
      mason = true;
      mini.enabled = true;
      telescope.enabled = true;
      treesitter = true;
      treesitter_context = true;
      which_key = true;
    };
  };
}
