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
      wezterm.terminfo
      pass
      azure-cli
      zellij
      lazygit
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
