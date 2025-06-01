{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { ... }@inputs:
  let
    system = "x86_64-linux";
    HOSTNAME = "visionary-computer";
    dotfile_dir = ./dotfile;
    nixosConfig = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        inherit dotfile_dir;
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
            backupFileExtension = "backup";
            extraSpecialArgs = {
              inherit dotfile_dir;
            };
            users.visionary = ./module/hm;
          };
        }
      ];
    };
  in
  {
    nixosConfigurations.${HOSTNAME} = nixosConfig;
  };
}