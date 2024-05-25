{ config, lib, pkgs, modulesPath, ... }:

let
  mountDevices = {
    nix = "/dev/disk/by-label/NIX";
    nixBoot = "/dev/disk/by-label/NIXBOOT";
    storage = "/dev/disk/by-label/STORAGE";
  };
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "module_blacklist=amdgpu" "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "ntfs" ];
  };

  fileSystems = {
    "/" = {
      device = mountDevices.nix;
      fsType = "btrfs";
      options = [ "subvol=root" "compress=lzo" "noatime" ];
    };

    "/home" = {
      device = mountDevices.nix;
      fsType = "btrfs";
      options = [ "subvol=home" "compress=lzo" "noatime" ];
    };

    "/nix" = {
      device = mountDevices.nix;
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=lzo" "noatime" ];
    };

    "/swap" = {
      device = mountDevices.nix;
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime" ];
    };

    "/boot" = {
      device = mountDevices.nixBoot;
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    "/mnt/storage" = {
      device = mountDevices.storage;
      fsType = "btrfs";
      options = [ "subvol=storage" "compress=lzo" "noatime" ];
    };

    "/mnt/snapshots" = {
      device = mountDevices.storage;
      fsType = "btrfs";
      options = [ "subvol=snapshots" "compress=zstd" "noatime" ];
    };
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 2048;
    randomEncryption.enable = true;
  }];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
