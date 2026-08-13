{ pkgs, dotfile_dir, ... }:
{
  # yazi - 终端文件管理器（TUI）
  programs.yazi = {
    enable = true;

    # Dracula 主题 flavor（官方 yazi-rs/flavors 仓库，兼容 yazi 26.x）
    # 注：dracula/yazi 仓库的 flavor.toml 是旧版格式（filetype 规则用 name 选择器），
    # 在 yazi 26.5.6 上会报 "at least one of url or mime must be specified"，故改用官方版
    flavors."dracula" = dotfile_dir + /.config/yazi/flavors/dracula.yazi;

    # 启用 dark 主题（flavor 需在 theme.toml 的 [flavor] 段声明）
    theme = {
      flavor = {
        dark = "dracula";
        light = "dracula";
      };
    };

    # fish 集成：提供 `ya` 包装命令，退出 yazi 后自动 cd 到其所在目录
    enableFishIntegration = true;

    # 预览依赖，仅注入 yazi 的 PATH，不污染全局环境
    extraPackages = with pkgs; [
      poppler-utils # PDF 预览（pdftoppm）
      ffmpegthumbnailer # 视频缩略图
      chafa # 图片预览（kitty 图形协议之外的兜底）
      p7zip # 7z 压缩包预览
      unzip # zip 压缩包预览
      mediainfo # 媒体文件元信息
    ];

    settings = {
      manager = {
        # 不区分大小写的自然排序（与 Dolphin 默认一致）
        sort_sensitive = false;
      };
    };
  };
}
