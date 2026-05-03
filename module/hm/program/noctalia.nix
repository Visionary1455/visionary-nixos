# Home Manager configuration for a Hyprland-based desktop session.

{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    plugins = {
      version = 2;
      sources = [
        {
          enabled = true;
          name = "Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        hostname = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
    };
    settings = {
      bar = {
        position = "top";
        density = "spacious";
        widgets = {
          left = [
            { id = "Launcher"; }
            { id = "plugin:hostname"; }
            { id = "SystemMonitor"; }
            { id = "MediaMini"; }
          ];
          center = [
            {
              id = "Workspace";
              labelMode = "name";
              characterCount = 8;
              showLabelsOnlyWhenOccupied = false;
              hideUnoccupied = false;
            }
          ];
          right = [
            {
              id = "VPN";
              displayMode = "alwaysShow";
            }
            {
              formatHorizontal = "MMM dd, h:mm ap";
              id = "Clock";
            }
            { id = "Tray"; }
            { id = "NotificationHistory"; }
            {
              id = "Battery";
              displayMode = "graphic";
            }
            { id = "Volume"; }
            { id = "ControlCenter"; }
          ];
        };
      };

      colorSchemes = {
        predefinedScheme = "Rosepine";
      };

      location = {
        use12hourFormat = true;
        useFahrenheit = true;
      };

      idle = {
        timeout = 300;
        lockTimeout = 600;
      };

      notifications = {
        position = "top-right";
        timeout = 5000;
      };

      appLauncher = {
        showIcons = true;
        showSearch = true;
      };

      wallpaper = {
        enable = true;
        fillMode = "fill";
      };
    };
  };
}