{ config, lib, modulePath, pkgs, ... }:

{
  system.stateVersion = "24.05";

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

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_zen;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "drdos8x16";
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      vaapiVdpau
      libvdpau
    ];
  };


  services = {
    xserver.videoDrivers = [ "nvidia" ];
    desktopManager.plasma6.enable = true;

    udev.extraRules = ''
      # PS5 DualSense controller over USB hidraw
      KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0660", TAG+="uaccess"

      # PS5 DualSense controller over bluetooth hidraw
      KERNEL=="hidraw*", KERNELS=="*054C:0CE6*", MODE="0660", TAG+="uaccess"
    '';

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
      settings = {
        /* Autologin = {
          Session = "plasma.desktop";
          User = "jtaylor";
          Relogin = true;
        }; */
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
      package = config.boot.kernelPackages.nvidiaPackages.beta;

      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;

      open = true;

      nvidiaSettings = true;
    };

    xone.enable = true;
  };
}
