{ pkgs, pkgs-unstable, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      git
      git-credential-manager
      wget
      curl
      wslu
      home-manager
      zsh
      zsh-powerlevel10k

      pkgs-unstable.lazygit
      pkgs-unstable.bat
      pkgs-unstable.eza
      pkgs-unstable.fzf
      pkgs-unstable.ripgrep
      pkgs-unstable.zoxide
      pkgs-unstable.neovim
    ];

    variables = {
      EDITOR = "nvim";
    };
  };
}
