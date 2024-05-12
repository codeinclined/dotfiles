{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      git
      git-credential-manager
      wget
      curl
      # TODO: Add proper option for toggling this
      #wslu
      home-manager
      zsh
      zsh-powerlevel10k
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

      wine-wayland
      wineWowPackages.waylandFull
    ];

    variables = {
      EDITOR = "nvim";
      STEAM_FORCE_DESKTOPUI_SCALING = "1.25";
    };

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
}
