{ inputs, pkgs, ... }:
{
  # Enable fish
  environment.systemPackages = with pkgs; [
    v2raya
  ];
  services.v2raya.enable = true;
}

