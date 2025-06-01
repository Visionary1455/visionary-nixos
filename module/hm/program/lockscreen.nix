{ lib, pkgs, dotfile_dir, ... }:

{
  home.packages = with pkgs; [
    hyprlock
  ];

  home.file = {
    # Hyprlock configs
    ".config/hypr/hyprlock.conf" = {
      source = dotfile_dir + /.config/hypr/hyprlock.conf;
      force = true;
    };
    ".config/hypr/hyprlock/Anurati.conf" = {
      source = dotfile_dir + /.config/hypr/hyprlock/Anurati.conf;
    };
    ".config/hypr/hyprlock/Arfan on Clouds.conf" = {
      source = dotfile_dir + "/.config/hypr/hyprlock/Arfan on Clouds.conf";
    };
    ".config/hypr/hyprlock/IBM Plex.conf" = {
      source = dotfile_dir + "/.config/hypr/hyprlock/IBM Plex.conf";
    };
    ".config/hypr/hyprlock/SF Pro.conf" = {
      source = dotfile_dir + "/.config/hypr/hyprlock/SF Pro.conf";
    };
    ".config/hypr/hyprlock/theme.conf" = {
      source = dotfile_dir + /.config/hypr/hyprlock/theme.conf;
      force = true;
    };
  };
  home.activation.installLockScreenConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # Get the default profile directory
    $DRY_RUN_CMD cp -rn $VERBOSE_ARG ${dotfile_dir}/picture/* ~/Pictures/
  '';
}
