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
    settings = {
      gui = {
        nerdFontsVersion = "3";
        filterMode = "fuzzy";

        theme = {
          activeBorderColor = [
            "#fab387"
            "bold"
          ];
          inactiveBorderColor = [
            "#a6adc8"
          ];
          optionsTextColor = [
            "#89b4fa"
          ];
          selectedLineBgColor = [
            "#313244"
          ];
          cherryPickedCommitBgColor = [
            "#45475a"
          ];
          cherryPickedCommitFgColor = [
            "#fab387"
          ];
          unstagedChangesColor = [
            "#f38ba8"
          ];
          defaultFgColor = [
            "#cdd6f4"
          ];
          searchingActiveBorderColor = [
            "#f9e2af"
          ];

          authorColors = {
            "*" = "#b4befe";
          };
        };
      };

      os = {
        open = "wslview {{filename}}";
        editPreset = "nvim";
        copyToClipboardCommand = "printf '{{text}}' | clip.exe";
      };
    };
  };
}
