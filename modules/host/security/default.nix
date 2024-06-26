{ pkgs, ... }:

{
  programs.gnupg = {
    agent = {
      enable = true;
      enableExtraSocket = true;
      pinentryPackage = pkgs.pinentry-gtk2;
      settings = {
        default-cache-ttl = 28800;
        max-cache-ttl = 28800;
      };
    };
  };
}
