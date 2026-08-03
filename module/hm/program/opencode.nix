{ lib, ... }:

{
  xdg.configFile."opencode/AGENTS.md" = {
    force = true;
    text = ''
      # Global Rules

      - 始终使用简体中文回复用户。
      - 代码、命令、文件名等保持原文，但解释和说明使用中文。
    '';
  };
}
