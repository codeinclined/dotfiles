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
      (azure-cli.override {
        withExtensions = [
          azure-cli.extensions.resource-graph
          azure-cli.extensions.ad
          azure-cli.extensions.azure-devops
        ];
      })
      bat
      eza
      fzf
      ripgrep
      zoxide
      neovim
    ];

    variables = {
      EDITOR = "nvim";
    };
  };
}
