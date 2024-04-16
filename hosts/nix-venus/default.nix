{ config, lib, pkgs, pkgs-unstable, inputs, modulePath, ... }:

{
  system.stateVersion = "23.11";

  imports = lib.lists.forEach [
    /nix
    /environment
    /users
    /wsl
    /shells/zsh
    /security
  ] (p: (modulePath + /host + p));

  time.timeZone = "America/Chicago";
  networking.hostName = "nixos-venus";
}
