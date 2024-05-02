{ config, lib, ... }:

{
  options.hm.zsh = {
    disable = lib.mkEnableOption (lib.mdDoc "Disable zsh");
  };

  config.programs.zsh = with config.hm.zsh; {
    enable = !disable;
    autocd = false;
    dotDir = ".config/zsh";
  };
}
