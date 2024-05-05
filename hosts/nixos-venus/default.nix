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

  services = {
    xserver.videoDrivers = [ "nvidia" ];
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };

  programs.gamemode.enable = true;

  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;

      open = false;

      nvidiaSettings = true;
    };

    xone.enable = true;
  };
}
