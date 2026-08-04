{
  description = "Visionary's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      system = "x86_64-linux";
      hostname = "visionary-computer";
      dotfile_dir = ./dotfile;

      nixosConfig = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs dotfile_dir;
        };
        modules = [
          ./host/configuration.nix
          ./host/hardware-configuration.nix
          ./module/system

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              verbose = true;
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backhm";
              extraSpecialArgs = {
                inherit inputs dotfile_dir;
              };
              users.visionary = ./module/hm;
            };
          }
        ];
      };
    in
    {
      nixosConfigurations.${hostname} = nixosConfig;
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
    };
}
