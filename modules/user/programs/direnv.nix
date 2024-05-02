{ config, lib, ... }:

{
  options.hm.direnv = {
    disable = lib.mkEnableOption (lib.mdDoc "Disable direnv");
  };

  config.programs.direnv = with config.hm.direnv; {
    enable = !disable;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
