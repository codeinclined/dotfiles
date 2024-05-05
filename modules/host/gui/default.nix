{ config, lib, pkgs, ... }:

{
  options = {
    nx.gui.enable = lib.mkEnableOption (lib.mdDoc "enable gui features");
  };

  config = {
    fonts = lib.mkIf config.nx.gui.enable {
      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        noto-fonts-extra
        liberation_ttf
        meslo-lgs-nf
        helvetica-neue-lt-std
      ];
    };

    programs = {
      steam = {
        enable = true;

        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
      };
    };

    # HACK: Split out the audio stuff
    security.rtkit.enable = config.nx.gui.enable;
    services.pipewire = lib.mkIf config.nx.gui.enable {
      enable = true;

      alsa.enable = true;
      alsa.support32Bit = true;

      pulse.enable = true;
      # jack.enable = true;

      wireplumber.configPackages = [
        (pkgs.writeTextDir "share/wireplumber/main.lua.d/99-alsa-lowlatency.lua" ''
          alsa_monitor.rules = {
            {
              matches = {{{ "node.name", "matches", "alsa_output.*" }}};
              apply_properties = {
                ["audio.format"] = "S32LE",
                ["audio.rate"] = "96000", -- for USB soundcards it should be twice your desired rate
                ["api.alsa.period-size"] = 2, -- defaults to 1024, tweak by trial-and-error
                -- ["api.alsa.disable-batch"] = true, -- generally, USB soundcards use the batch mode
              },
            },
          }
        '')
      ];

      /* wireplumber.extraLuaConfig.main."99-alsa-lowlatency" = ''
        alsa_monitor.rules = {
          {
            matches = {{{ "node.name", "matches", "alsa_output.*" }}};
            apply_properties = {
              ["audio.format"] = "S32LE",
              ["audio.rate"] = "96000", -- for USB soundcards it should be twice your desired rate
              ["api.alsa.period-size"] = 2, -- defaults to 1024, tweak by trial-and-error
              -- ["api.alsa.disable-batch"] = true, -- generally, USB soundcards use the batch mode
            },
          },
        }
      ''; */

      extraConfig = {
        pipewire-pulse."92-low-latency" = {
          context.modules = [
            {
              name = "libpipewire-module-protocol-pulse";
              args.pulse = {
                min.req = "32/48000";
                min.quantum = "32/48000";
                default.req = "32/48000";
                max.req = "32/48000";
                max.quantum = "32/48000";
              };
            }
          ];

          stream.properties = {
            node.latency = "32/48000";
            resample.quality = 1;
          };
        };

        pipewire."92-low-latency" = {
          context.properties = {
            default.clock = {
              rate = 48000;
              quantum = 32;
              min-quantum = 32;
              max-quantum = 32;
            };
          };
        };
      };
    };
  };
}
