{
  inputs,
  nixpkgs,
  system,
}:
nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = {
    inherit inputs;
  };
  modules = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../module/system

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        verbose = true;
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backhm";
        extraSpecialArgs = {
          inherit inputs;
          dotfile_dir = ../dotfile;
        };
        users.visionary = ../module/hm;
      };
    }
  ];
}
