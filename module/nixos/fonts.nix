{ pkgs, ... }:

{
  # Fonts
  fonts.packages = with pkgs; [   
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    jetbrains-mono
    nerd-font-patcher
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.noto
    nerd-fonts.hack
    nerd-fonts.ubuntu
  ];
}
