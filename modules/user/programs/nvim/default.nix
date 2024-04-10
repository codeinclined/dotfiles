{ ... }:

{
  imports = [
    ./opts.nix
    ./keymaps.nix
    ./plugins.nix
    ./autocmds.nix
    ./colorschemes.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    luaLoader.enable = true;
  };
}
