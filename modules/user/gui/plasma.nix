{ pkgs, ... }:

let
  mkSpacerEx = length: expanding: {
    name = "org.kde.plasma.panelspacer";
    config.General = { inherit length expanding; };
  };

  mkSpacer = length: (mkSpacerEx length (length > 0));

  kickoff = {
    name = "org.kde.plasma.kickoff";
    config.General = {
      icon = "nix-snowflake";
      primaryActions = 3;
    };
  };

  taskManager = {
    name = "org.kde.plasma.icontasks";
    config.General = {
      launchers = [
        "applications:systemsettings.desktop"
        "applications:org.wezfurlong.wezterm.desktop"
        "preferred://filemanager"
        "preferred://browser"
        "applications:steam.desktop"
        "applications:xivlauncher.desktop"
      ];
    };
  };

  weather = {
    name = "org.kde.plasma.weather";
    config.WeatherStation = { };
  };
in
{
  programs.plasma = {
    enable = true;

    overrideConfig = true;

    workspace = {
      clickItemTo = "select";
      theme = "breeze-dask";
      colorScheme = "BreezeDark";
      lookAndFeel = "org.kde.breezedark.desktop";
      iconTheme = "breeze-dark";
    };

    fonts = {
      fixedWidth = {
        family = "CommitMono Nerd Font";
        pointSize = 10;
      };
    };

    panels = [
      {
        height = 30;
        location = "top";
        floating = false;
        screen = 0;
        widgets = [
          (mkSpacer 5)
          kickoff
          (mkSpacer 5)
          "org.kde.plasma.appmenu"
          (mkSpacer 0)
          taskManager
          (mkSpacer 0)
          { systemTray.items = { }; }
          (mkSpacer 5)
          {
            digitalClock = {
              calendar.firstDayOfWeek = "sunday";
              time.format = "12h";

              date = {
                enable = true;
                format = { custom = "dddd, dd MMM yyyy"; };
                position = "besideTime";
              };
            };
          }
          (mkSpacer 5)
          "org.kde.plasma.lock_logout"
          (mkSpacer 5)
        ];
      }
    ];
  };
}
