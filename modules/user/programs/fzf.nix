{ config, lib, ... }:

{
  options.hm.fzf = {
    disable = lib.mkEnableOption (lib.mdDoc "Disable fzf");
  };

  config.programs.fzf = with config.hm.fzf; {
    enable = !disable;
    enableZshIntegration = true;
  };
}
