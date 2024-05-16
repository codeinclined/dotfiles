_:

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

    splitright = true;
    splitbelow = true;
  };

  programs.nixvim.globals = {
    mapleader = " ";
    maplocalleader = " ";
  };
}
