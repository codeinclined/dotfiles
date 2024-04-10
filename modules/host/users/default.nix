{ pkgs, ... }:

{
  security.sudo.wheelNeedsPassword = false;

  users = {
    defaultUserShell = pkgs.zsh;

    users = {
      jtaylor = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };
    };
  };
}
