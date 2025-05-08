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
          ./host/hardware-configuration.nix
          ./module/users.nix

          ./module/nixos/bootloader.nix
          ./module/nixos/auto-upgrade
          ./module/nixos/gc.nix
          ./module/nixos/fonts.nix

          ./module/base/networking.nix
          ./module/base/open-ssh.nix
          ./module/base/nvidia.nix
          ./module/base/opengl.nix
          ./module/base/sound.nix
          ./module/base/usb.nix
          ./module/base/bluetooth.nix
          ./module/base/fcitx5.nix

          ./module/displaymanager/display-manager.nix

          ./module/program/lsp.nix
          ./module/program/hyprland.nix
          ./module/program/fish.nix
        ];
      };
    };
  };
}