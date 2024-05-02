{ pkgs, ... }:

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
      zsh-vi-mode
      wezterm.terminfo
      pass
      azure-cli
      bat
      eza
      fzf
      ripgrep
      zoxide
      neovim-nightly
    ];

    variables = {
      EDITOR = "nvim";
    };
  };
}
