{ inputs, pkgs, lib, ... }:
let
    USERNAME = "visionary";
in
{
  home.activation.createHyprConfigs = lib.hm.dag.entryAfter [ "mutableGeneration" ] ''
    mkdir -p "$HOME/.config/fastfetch/logo"
    mkdir -p "$HOME/.config/menus"
  '';
  # Define a user account. Don't forget to set a password with ‘passwd’.
  # home-manager
  home = rec {
    username = "${USERNAME}";
    homeDirectory = lib.mkForce "/home/${USERNAME}";
    stateVersion = lib.trivial.release;
    
  };
  imports = [
    ./base/mutable.nix
    ./program/hyprland.nix
    ./program/git.nix
    ./program/dolphin.nix 
    ./program/fastfetch.nix
    ./program/firefox.nix

    # Nix-index-database - for comma and command-not-found
    # inputs.nix-index-database.hmModules.nix-index
  ];
  # # Change runtime directory size
  # services.logind.extraConfig = "RuntimeDirectorySize=8G";
}
