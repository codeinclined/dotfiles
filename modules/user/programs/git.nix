{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Josh Taylor";
    userEmail = "taylor.joshua88@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;

      credential = {
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
        credentialStore = "cache";
      };
    };
  };
}
