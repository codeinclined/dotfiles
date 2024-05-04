{ modulePath, ... }:

{
  imports = [ (modulePath + /user) ];

  home = {
    stateVersion = "23.11";

    username = "jtaylor";
    homeDirectory = "/home/jtaylor";
  };

  programs.home-manager.enable = true;
}
