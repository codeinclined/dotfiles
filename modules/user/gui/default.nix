{ config, lib, pkgs, ... }:

{
  options = {
    hm.gui.disable = lib.mkEnableOption (lib.mdDoc "disable gui support");
  };

  config = {
    services = {
      spotifyd = {
        enable = true;
        settings.global = {
          username_cmd = "pass show trusted/spotifyd/user";
          password_cmd = "pass show trusted/spotifyd/password";
          use_mpris = true;
          dbus_type = "session";
          device_name = "nixos-venus";
          bitrate = 320;
          no_audio_cache = true;
          initial_volume = "90";
          volume_normalisation = true;
          autoplay = true;
          device_type = "computer";
        };
      };
    };

    programs.wezterm = {
      enable = !config.hm.gui.disable;
      extraConfig = builtins.readFile ./wezterm.lua;
    };

    programs.chromium = {
      enable = !config.hm.gui.disable;
      package = pkgs.brave;
      extensions = [
        # Microsoft Autofill
        { id = "fiedbfgcleddlbcmgdigjgdfcggjcion"; }
        # Dark Reader
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }
        # Plasma Integration
        { id = "cimiefiiaegbelhefglklhhakcgmhkai"; }
        # Tabliss
        { id = "hipekcciheckooncpjeljhnekcoolahp"; }
      ];
    };
  };
}
