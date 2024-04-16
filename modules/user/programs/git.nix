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
        credentialStore = "gpg";
        useHttpPath = true;
      };
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        nerdFontsVersion = "3";
        filterMode = "fuzzy";
      };

      os = {
        open = "wslview {{filename}}";
        editPreset = "nvim";
        copyToClipboardCommand = "printf '{{text}}' | clip.exe";
      };
    };
  };
}
