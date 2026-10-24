{ config, inputs, ... }:

{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    defaultSopsFile = "${inputs.self}/sops/secrets.yaml";
    age.keyFile = "/home/${config.home.username}/.config/sops/age/keys.txt";
  };
}
