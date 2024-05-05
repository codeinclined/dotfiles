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
      neovim

      # TODO: MAKE THIS NOT INSTALLED IN WSL
      kdePackages.plasma-browser-integration
    ];

    variables = {
      EDITOR = "nvim";
    };

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      STEAM_FORCE_DESKTOPUI_SCALING = 1.25;
    };
  };
}
