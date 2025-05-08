{ pkgs, ... }:

{
  # Enable networking
  networking = {
    hostName = "nixos"; # Define your hostname.
    networkmanager.enable = true;
    wireless.networks = {
	"1912-2" = {
	  pskRaw = "d8c55e70a8f2209ced73ea8cdfc33ef0a1ab88386bca85fdf1f67d5c37a856dd";
    };
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  environment.systemPackages = with pkgs; [
    iwgtk
    impala
  ];
}
