{ ... }:

{
  programs.nixvim.opts = {
    number = true;
    relativenumber = true;
    undofile = true;
    timeoutlen = 300;

    tabstop = 4;
    updatetime = 250;
    signcolumn = "yes";
    breakindent = true;

    list = true;
    listchars = "tab:󰌒\ ,trail:·,nbsp:󱁐";
  };

  programs.nixvim.globals = {
    mapleader = " ";
    maplocalleader = " ";
  };
}
