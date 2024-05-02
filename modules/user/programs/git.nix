{ pkgs, config, lib, ... }:

{
  options.hm.git = {
    disable = lib.mkEnableOption (lib.mdDoc "Disable git");
    lazygit.disable = lib.mkEnableOption (lib.mdDoc "Disable lazygit");
  };

  config.programs.git = with config.hm.git; {
    enable = !disable;
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

  config.programs.lazygit = with config.hm.git; {
    enable = !disable && !lazygit.disable;
    settings = with lazygit; {
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
