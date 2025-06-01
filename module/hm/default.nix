{ inputs, pkgs, lib, ... }:
let
    USERNAME = "visionary";
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  # home-manager
  home = rec {
    username = "${USERNAME}";
    homeDirectory = lib.mkForce "/home/${USERNAME}";
    stateVersion = lib.trivial.release;
    
  };
  imports = [
    ./program/hyprland.nix
    ./program/git.nix
    ./program/dolphin.nix 

    # Nix-index-database - for comma and command-not-found
    # inputs.nix-index-database.hmModules.nix-index
  ];
  # # Change runtime directory size
  # services.logind.extraConfig = "RuntimeDirectorySize=8G";
}
