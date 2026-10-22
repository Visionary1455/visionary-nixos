{ inputs, ... }:
{
  imports = [ inputs.nix-skills.homeManagerModules.default ];

  # olafkfreund/nix-skills：基于上游 Nix/NixOS/Home Manager 文档构建的技能集合。
  # agents = [ "opencode" ] 会把全部技能链接到 ~/.config/opencode/skills/<name>。
  programs.nix-skills = {
    enable = true;
    agents = [ "opencode" ];
  };
}
