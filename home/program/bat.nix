{ ... }:
{
  # bat - 带语法高亮的 cat 替代品
  programs.bat = {
    enable = true;
  };

  # Ubuntu 下 bat 命令名为 batcat, 提供同名别名
  home.shellAliases.batcat = "bat";
}
