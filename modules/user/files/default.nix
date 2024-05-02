{ config, lib, ... }:

{
  options.hm.files = {
    disable = lib.mkEnableOption (lib.mdDoc "Disable extra file generation");
    editorconfig.disable = lib.mkEnableOption (lib.mdDoc "Disable .editorconfig generation");
  };

  config.editorconfig = with config.hm.files; {
    enable = !disable && !editorconfig.disable;
    settings = with editorconfig; {
      "*" = {
        end_of_line = "lf";
        insert_final_newline = true;
        charset = "utf-8";
        indent_style = "space";
        indent_size = 2;
      };

      "{*.go,go.mod}" = {
        indent_style = "tab";
      };

      "Makefile" = {
        indent_style = "tab";
      };
    };
  };
}
