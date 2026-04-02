{ inputs, pkgs, ... }:
let
  fcitx5-pinyin-moegirl = pkgs.callPackage ../../../overlays/fcitx5-pinyin-moegirl { };
  fcitx5-pinyin-zhwiki = pkgs.callPackage ../../../overlays/fcitx5-pinyin-zhwiki { };
in
{
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
    };
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
    inputMethod = {
      #enabled = "fcitx5";
      type = "fcitx5";
      enable = true;

      fcitx5 = {
        # waylandFrontend = true; #
        # plasma6Support = true; #不用kde6 貌似不用启用
        addons = with pkgs; [
          qt6Packages.fcitx5-chinese-addons
          fcitx5-mozc
          fcitx5-gtk #  Fcitx5 gtk im module and glib based dbus client library
          fcitx5-material-color
          fcitx5-pinyin-moegirl
          fcitx5-pinyin-zhwiki
        ];
        #ignoreUserConfig = true; #启用不光个人设置无效，个人词库也会无法保存 
        settings = {
          addons = {
            classicui.globalSection.Theme = "Material-Color-deepPurple";
            classicui.globalSection.DarkTheme = "Material-Color-deepPurple";
            pinyin.globalSection = {
              PageSize = 9;
              CloudPinyinEnabled = "True";
              CloudPinyinIndex = 2;
            };
            cloudpinyin.globalSection = {
              Backend = "Baidu";
            };
          };
          #globalOptions = { "Hotkey/TriggerKeys" = { "0" = "Alt+space"; }; };
          inputMethod = {
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "keyboard-us";
            };
            "Groups/0/Items/0".Name = "keyboard-us";
            "Groups/0/Items/1".Name = "pinyin";
            GroupOrder."0" = "Default";
          };
        };
      };
      fcitx5.waylandFrontend = true;
    };
  };
  # 中文字体优化
  fonts = {
    fontDir.enable = true; # 启用旧版字体路径兼容
    packages = with pkgs; [
      cascadia-code
      noto-fonts 
      noto-fonts-cjk-sans    # 思源黑体
      noto-fonts-cjk-serif   # 思源宋体
      noto-fonts-color-emoji
      source-han-sans        # 思源黑体
    ];
    
    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Noto Sans CJK SC" "DejaVu Sans" ];
        serif = [ "Noto Serif CJK SC" "DejaVu Serif" ];
        monospace = [ "Cascadia Code" "Noto Sans Mono CJK SC" ];
      };
    };
  };
  environment.variables = {
    #GTK_IM_MODULE = "fcitx";
    #QT_IM_MODULE = "fcitx";
    #XMODIFIERS = "@im=fcitx";
  };
}