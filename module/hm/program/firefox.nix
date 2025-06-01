{ config, lib, pkgs, dotfile_dir, ... }:
{
  home.packages = with pkgs; [
    firefox # browser
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Apply HyDE Firefox configuration if enabled
  home.activation.installHydeFirefoxConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # Get the default profile directory
    PROFILE_DIR=$(find ~/.mozilla/firefox -name "*.default" -type d 2>/dev/null || echo "")
    if [ -z "$PROFILE_DIR" ]; then
      echo "No default Firefox profile found. Creating one may require running Firefox first."
    else
      # Create chrome directory if it doesn't exist
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG "$PROFILE_DIR/chrome"
      
      # Install extensions if enabled
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/.mozilla/firefox
      $DRY_RUN_CMD cp -rf $VERBOSE_ARG ${dotfile_dir}/.config/firefox/extensions/* ~/.mozilla/
      
      # Install userChrome.css if enabled
      $DRY_RUN_CMD cp -rf $VERBOSE_ARG ${dotfile_dir}/.config/firefox/userconfig/chrome/* "$PROFILE_DIR/chrome/"
      
      # Install user.js if enabled
      $DRY_RUN_CMD cp -rf $VERBOSE_ARG ${dotfile_dir}/.config/firefox/userconfig/user.js "$PROFILE_DIR/"
    fi
  '';
}
