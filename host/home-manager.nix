{ inputs, identity, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  # Home Manager 作为 NixOS 模块运行：用户环境随系统 rebuild 一起激活。
  home-manager = {
    verbose = true;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backhm";
    extraSpecialArgs = {
      inherit inputs identity;
      dotfile_dir = ../dotfile;
    };
    users.${identity.username} = ../module/hm;
  };
}
