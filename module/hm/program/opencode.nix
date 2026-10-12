{
  pkgs,
  dotfile_dir,
  ...
}:

{
  home.packages = with pkgs; [
    # opencode.jsonc 的 mcp.browsermcp 通过 `npx -y @browsermcp/mcp@0.1.3` 启动，需要 nodejs/npx；
    # @browsermcp/mcp 每次启动都会执行 `lsof -ti:9009 | xargs kill -9` 清理占端口的旧实例
    # （单实例设计：后启动者接管），缺 lsof 时新实例会挂死在"等待端口释放"循环里，
    # opencode 侧表现为 mcp connect failed "Request timed out"（30s 超时）
    nodejs
    lsof
  ];

  xdg.configFile."opencode/AGENTS.md" = {
    force = true;
    text = ''
      # Global Rules

      - 始终使用简体中文回复用户。
      - 代码、命令、文件名等保持原文，但解释和说明使用中文。
    '';
  };

  # i-have-adhd 插件文件（ADHD 友好输出风格，按需启用 /i-have-adhd）。
  # 注意：该插件是 V1 格式（默认导出 async 函数），V2 要求默认导出含 id+effect/setup，
  # 已从 opencode.jsonc 的 plugin 列表移除；SKILL.md/command 文件仍部署在此，等上游
  # 出 V2 格式后可直接恢复引用。
  xdg.configFile."opencode/vendor/i-have-adhd/.opencode/plugins/i-have-adhd.mjs".source =
    dotfile_dir + /.config/opencode/vendor/i-have-adhd/.opencode/plugins/i-have-adhd.mjs;
  xdg.configFile."opencode/vendor/i-have-adhd/.opencode/command/i-have-adhd.md".source =
    dotfile_dir + /.config/opencode/vendor/i-have-adhd/.opencode/command/i-have-adhd.md;
  xdg.configFile."opencode/vendor/i-have-adhd/skills/i-have-adhd/SKILL.md".source =
    dotfile_dir + /.config/opencode/vendor/i-have-adhd/skills/i-have-adhd/SKILL.md;

  # grill-me skill（压力测试计划/设计，按需启用 /grill-me）
  xdg.configFile."opencode/vendor/grill-me/skills/grill-me/SKILL.md".source =
    dotfile_dir + /.config/opencode/vendor/grill-me/skills/grill-me/SKILL.md;
  xdg.configFile."opencode/vendor/grill-me/skills/grilling/SKILL.md".source =
    dotfile_dir + /.config/opencode/vendor/grill-me/skills/grilling/SKILL.md;

  # opencode server 端插件（npm 包由 opencode 启动时自动安装到 ~/.cache/opencode/node_modules）：
  # - oh-my-openagent：背景代理/LSP/MCP 工具全家桶。上游已从 oh-my-opencode 改名（npm 包名
  #   同为 oh-my-openagent），5.x 为 V2 格式（默认导出含 id/effect/setup）可正常加载；老的
  #   oh-my-opencode 仍是 V1 格式，在 V2 下必然加载失败（issue #9241），勿回退
  # - opencode-browser：V1 插件，V2 不兼容（SchemaError: Expected object at ["default"]，上游
  #   2 个 V2 issue 未修），已移除；等上游 V2 适配后可直接加回 "opencode-browser"
  # - i-have-adhd：V1 插件格式（默认导出为 async 函数），V2 要求默认导出含 id+effect/setup，
  #   已从 plugin 列表移除；SKILL.md/command 文件仍部署在 vendor/ 下备恢复
  xdg.configFile."opencode/opencode.jsonc" = {
    force = true;
    text = ''
      {
        "$schema": "https://opencode.ai/config.json",
        "plugin": [
          "oh-my-openagent"
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
  # 提供 /commit 斜杠命令生成 Conventional Commit 消息，必须写在 cli.json
  # （V2 schema https://opencode.ai/v2/cli.json；plugins 为对象形 {"package","options"}；
  #  V1 的分层 tui.jsonc 已废弃，V2 不再读取）。theme/animations 保持与 V2 首次启动
  # 自动生成的 cli.json 一致。
  xdg.configFile."opencode/cli.json" = {
    force = true;
    text = ''
      {
        "$schema": "https://opencode.ai/v2/cli.json",
        "plugins": [
          { "package": "@andre-barbosa/opencode-commit", "options": { "model": "opencode/deepseek-v4-flash-free" } }
        ],
        "theme": {
          "mode": "light"
        },
        "animations": true
      }
    '';
  };
}
