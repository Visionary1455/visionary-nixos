{ inputs, pkgs, ... }:
{
  # Enable fish
  programs.git = {
    enable = true;
    userName  = "Visionary";
    userEmail = "15282219250@163.com";
  };
  users.users.visionary = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF38sHxXn/r7KzWL1BVCqcKqmZA/V76N/y5p52UQghw7 example"
    ];
}
