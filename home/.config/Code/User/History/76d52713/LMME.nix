{ inputs, pkgs, ... }:

{
  i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      rime-data
      fcitx5-chinese-addons
      fcitx5-rime
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-im
      fcitx5-pinyin-zhwiki
    ];
  };
  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };
}