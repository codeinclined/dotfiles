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
      nfs-utils
      keymapp

      # TODO: MAKE THIS NOT INSTALLED IN WSL
      kdePackages.plasma-browser-integration

      (wineWowPackages.waylandFull.override { wineRelease = "staging"; })

      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
    ];

    variables = {
      EDITOR = "nvim";
    };

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
      STEAM_FORCE_DESKTOPUI_SCALING = "1.25";
      GDK_BACKEND = "wayland,x11";
      ANKI_WAYLAND = "1";
      QB_QPA_PLATFORM = "wayland;xcb";
      WLR_BACKEND = "vulkan";
      WLR_RENDERER = "vulkan";
      XDG_SESSION_TYPE = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      WLR_DRM_DEVICES = "/dev/dri/card0";
    };
  };
}
