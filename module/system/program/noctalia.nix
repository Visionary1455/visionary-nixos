{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default 
    # ... 可能还有其他软件包
  ];
  programs.noctalia-shell = {
    enable = true;
    settings = {
      plugins = {
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];
        states = {
          weekly-calendar = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
        };
        version = 1;
      };

      bar = {
        density = "default";
        position = "right";
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
            {
              id = "WiFi";
            }
            {
              id = "VPN";
            }
            {
              id = "Bluetooth";
            }
          ];
          center = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
          ];
          right = [
            {
              id = "Tray";
            }
            {
              alwaysShowPercentage = true;
              id = "Battery";
              warningThreshold = 20;
            }
            {
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };

      dock = {
        enabled = false;
      };

      colorSchemes.predefinedScheme = "Monochrome";
      location = {
        monthBeforeDay = true;
        name = "Rennes, France";
      };
    };
  };
}
