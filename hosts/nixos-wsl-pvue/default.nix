{ lib, modulePath, ... }:

{
  system.stateVersion = "23.11";

  imports = lib.lists.forEach [
    /nix
    /environment
    /users
    /wsl
    /shells/zsh
    /security
  ]
    (p: (modulePath + /host + p));

  time.timeZone = "America/Chicago";

  wsl.wslConf.network.generateResolvConf = false;

  networking = {
    hostName = "nixos-wsl-pvue";

    nameservers = [
      "10.10.10.10"
      "10.10.10.11"
      "8.8.8.8"
      "8.8.4.4"
    ];
  };
}
