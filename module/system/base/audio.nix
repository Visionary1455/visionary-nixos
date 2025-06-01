{ pkgs, ... }:

{
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      wireplumber.enable = true;
    };
    blueman.enable = true;
  };

  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
    blueman
    pipewire
    wireplumber
    pavucontrol
    pamixer
    playerctl
  ];
}
