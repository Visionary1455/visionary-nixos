{ pkgs, ... }:
{
  # yazi - 终端文件管理器（TUI）
  programs.yazi = {
    enable = true;

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
