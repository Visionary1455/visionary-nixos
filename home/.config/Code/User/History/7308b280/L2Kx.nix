{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager,  ... }:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations = {
      nixos-computer = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./host/configuration.nix
          ./module/nixos/auto-upgrade
          ./module/nixos/gc.nix
        ];
      };
    };
  };
}