{ config, lib, modulePath, ... }:

{
  system.stateVersion = "23.11";

  imports = lib.lists.forEach [
    /nix
    /environment
    /users
    /hardware
    /shells/zsh
    /security
    /gui
  ]
    (p: (modulePath + /host + p));

  nx.gui.enable = true;

  time.timeZone = "America/Chicago";
  networking.hostName = "nixos-venus";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  i18n.defaultLocale = "en_US.UTF-8";

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  environment.sessionVariables.SDL_VIDEODRIVER = "wayland";

  services = {
    xserver.videoDrivers = [ "nvidia" ];
    desktopManager.plasma6.enable = true;

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
      settings = {
        Autologin = {
          Session = "plasma.desktop";
          User = "jtaylor";
          Relogin = true;
        };
      };
    };
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        inhibit_screensaver = 0;
        renice = 20;
      };

      gpu = {
        # apply_gpu_optimisations = "accept-responsibility";
        # gpu_device = 1;
      };

      cpu = {
        desiredgov = "performance";
        defaultgov = "powersave";
        park_cores = "no";
        pin_cores = "yes";
      };
    };
  };

  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;

      open = false;

      nvidiaSettings = true;
    };

    xone.enable = true;
  };
}
