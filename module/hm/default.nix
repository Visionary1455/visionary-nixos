{ inputs, pkgs, lib, ... }:
let
    USERNAME = "visionary";
in
{
  home.activation.createHyprConfigs = lib.hm.dag.entryAfter [ "mutableGeneration" ] ''
    mkdir -p "$HOME/.config/fastfetch/logo"
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
    ./base/xdg.nix
    ./base/qt.nix

    ./program

    # Nix-index-database - for comma and command-not-found
    # inputs.nix-index-database.hmModules.nix-index
  ];
}
