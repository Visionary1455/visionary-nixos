{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # opencode-browser 插件依赖 Browser MCP（通过 npx 启动），需要 nodejs/npx
    nodejs
  ];

  xdg.configFile."opencode/AGENTS.md" = {
    force = true;
    text = ''
      # Global Rules

      - 始终使用简体中文回复用户。
      - 代码、命令、文件名等保持原文，但解释和说明使用中文。
    '';
  };

  # opencode server 端插件（npm 包由 opencode 启动时自动安装到 ~/.cache/opencode/node_modules）：
  # - oh-my-opencode：背景代理/LSP/MCP 工具全家桶（当前 GitHub 已改名 oh-my-openagent，npm 仍叫 oh-my-opencode）
  # - opencode-browser：集成 Browser MCP 的浏览器自动化，需配合浏览器中的 Browser MCP 扩展使用
  xdg.configFile."opencode/opencode.jsonc" = {
    force = true;
    text = ''
      {
        "$schema": "https://opencode.ai/config.json",
        "plugin": [
          "oh-my-opencode",
          "opencode-browser"
        ],
        "mcp": {
          "browsermcp": {
            "type": "local",
            "command": ["npx", "-y", "@browsermcp/mcp@0.1.3"],
            "enabled": true
          }
        }
      }
    '';
  };

  # TUI 插件：opencode-commit（@andre-barbosa/opencode-commit）是 TUI-only 插件，
  # 提供 /commit 斜杠命令生成 Conventional Commit 消息，必须配置在 tui.json
  xdg.configFile."opencode/tui.jsonc" = {
    force = true;
    text = ''
      {
        "$schema": "https://opencode.ai/tui.json",
        "plugin": [
          ["@andre-barbosa/opencode-commit", { "model": "opencode/deepseek-v4-flash-free" }]
        ]
      }
    '';
  };
}
