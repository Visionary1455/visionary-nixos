{
  inputs,
  nixpkgs,
  identity,
}:
nixpkgs.lib.nixosSystem {
  inherit (identity) system;
  specialArgs = {
    inherit inputs identity;
  };
  modules = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./home-manager.nix

    ../module/system
  ];
}
