{ inputs, outputs, lib, config, pkgs, modulePath, ... }: 

{
  imports = lib.lists.forEach [
    /files
    /programs/nvim
    /programs/direnv.nix
    /programs/fzf.nix
    /programs/git.nix
    /programs/zsh.nix
  ] (p: (modulePath + /user + p));

  home = {
    stateVersion = "23.11";

    username = "jtaylor";
    homeDirectory = "/home/jtaylor";
  };

  programs.home-manager.enable = true;
}
