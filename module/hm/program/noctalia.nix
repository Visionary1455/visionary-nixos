# Home Manager configuration for a noctalia-based desktop session.
# noctalia v5：配置为 TOML 格式，选项名为 programs.noctalia。
# 启动方式由 niri.nix 中的 spawn-at-startup "noctalia" 负责。

{
  inputs,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;

    settings = {
      shell = {
        launcher = {
          show_icons = true;
          categories = true;
        };
      };

      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Rosé Pine";
      };

      wallpaper = {
        enabled = true;
        fill_mode = "crop";
      };

      notification = {
        enable_daemon = true;
        layer = "top";
      };

      idle = {
        behavior = {
          lock = {
            timeout = 300;
            action = "lock";
            enabled = true;
          };
          "screen-off" = {
            timeout = 600;
            action = "screen_off";
            enabled = true;
          };
        };
      };

      weather = {
        enabled = false;
        unit = "fahrenheit";
      };

      bar = {
        main = {
          position = "top";
          thickness = 44;
          widget_spacing = 8;
          start = [
            "launcher"
            "sysmon"
            "taskbar"
          ];
          center = [
            "workspaces"
            "media"
          ];
          end = [
            "clock"
            "network"
            "tray"
            "notifications"
            "battery"
            "volume"
            "control-center"
            "session"
          ];
        };
      };

      widget = {
        clock = {
          format = "{:%b %d, %I:%M %p}";
        };
        workspaces = {
          show_labels = true;
          label_source = "id";
          labels_only_when_occupied = false;
          max_label_chars = 8;
          hide_when_empty = false;
        };
        taskbar = {
          show_all_outputs = true;
          show_active_indicator = true;
        };
        network = {
          vpn_status = "both";
          show_vpn_label = true;
        };
      };
    };
  };
}
