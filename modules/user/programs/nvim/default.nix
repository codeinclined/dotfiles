{ config, lib, ... }:

let
  mkTreesitterQuerySet = path: lib.attrsets.genAttrs
    (
      lib.lists.forEach
        (builtins.filter (p: lib.strings.hasSuffix ".scm" (toString p)) (lib.filesystem.listFilesRecursive path))
        (p: (lib.strings.removePrefix ((toString ./.) + "/") (toString p)))
    )
    (
      n: builtins.readFile (./. + (/. + n))
    );
in
{
  imports = [
    ./opts.nix
    ./keymaps.nix
    ./plugins.nix
    ./autocmds.nix
    ./colorschemes.nix
  ];

  options.hm.nvim = {
    disable = lib.mkEnableOption (lib.mdDoc "Disable neovim");
  };

  config.programs.nixvim = with config.hm.nvim; {
    enable = !disable;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    luaLoader.enable = true;
    extraFiles = mkTreesitterQuerySet ./queries;
  };
}
