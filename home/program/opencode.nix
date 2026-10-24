{
  config,
  inputs,
  pkgs,
  dotfile_dir,
  ...
}:

let
  # opencode 2（V2 CLI）来自 flake input（nixpkgs 的 opencode 仍是 1.x）。
  # 系统 PATH 里也有同名二进制（system/default.nix），但服务直接引用
  # store 路径，不依赖 PATH。
  opencode2 = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode2;

  # sops-nix 渲染的口令 env 文件（见下方 sops.templates）
  envFile = config.sops.templates."opencode2-serve-env".path;
in

{
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

  # opencode server 配置。
  # npm 插件由 opencode 启动时自动安装到 ~/.cache/opencode/node_modules，不经过 nix store。
  # - oh-my-opencode-slim：多智能体编排插件（orchestrator/explorer/oracle/librarian/designer/fixer
  #   等）。V2 会优先解析包的 `./server` 子路径（自包含 bundle），v2.0.7+ 可用（本机 v2.1.0）。
  #   **必须锁精确版本**：V2 对未锁版本的 npm 插件每次启动都会自动升级，写 `@latest` 等于静默升级；
  #   锁定条目才是真正的版本锁。其模型配置见下方 oh-my-opencode-slim.jsonc。
  xdg.configFile."opencode/opencode.jsonc" = {
    force = true;
    text = ''
      {
        "$schema": "https://opencode.ai/config.json",
        "plugin": ["oh-my-opencode-slim@3.0.4"],

        // 实验特性（opencode 2.1.0+）：向模型提供 todowrite 工具，
        // 并在会话视图与侧边栏显示任务列表。
        // 默认权限策略为 allow，无需额外 permission 规则。
        "experimental": {
          "todo": true
        }
      }
    '';
  };

  # oh-my-opencode-slim 的模型配置（插件读取 ~/.config/opencode/oh-my-opencode-slim.jsonc，
  # .jsonc 优先于 .json）。本机只认证了 opencode 提供商（其余 auth list 为空），故按 opencode 的
  # 免费模型分配一支 preset（名为 "opencode"）。模型与 variant 都只是起点，可随时调整：
  # variant 仅对部分模型有效（big-pickle/nemotron-lightning 等无 variant，省略即用默认）。
  # 说明：orchestrator 负责规划与委派，选判断力较强的；explorer/librarian 负责侦察与检索，选快的；
  # designer/fixer 负责 UI 与实现。council 需 council.presets 才可用，这里给两个不同模型做交叉。
  xdg.configFile."opencode/oh-my-opencode-slim.jsonc" = {
    force = true;
    text = ''
      {
        "$schema": "https://unpkg.com/oh-my-opencode-slim@3.0.4/oh-my-opencode-slim.schema.json",
        "preset": "opencode",
        "presets": {
          "opencode": {
            "orchestrator": {
              "model": "opencode/big-pickle",
              "skills": ["*"],
              "mcps": ["*"]
            },
            "oracle": {
              "model": "opencode/space-bunny-free",
              "variant": "high",
              "skills": ["simplify"],
              "mcps": []
            },
            "librarian": {
              "model": "opencode/nemotron-3.5-lightning-free",
              "skills": [],
              "mcps": ["context7", "gh_grep"]
            },
            "explorer": {
              "model": "opencode/nemotron-3.5-lightning-free",
              "skills": [],
              "mcps": []
            },
            "designer": {
              "model": "opencode/muse-spark-1.3-contributor-free",
              "variant": "medium",
              "skills": [],
              "mcps": []
            },
            "fixer": {
              "model": "opencode/step-5-preview-free",
              "variant": "high",
              "skills": [],
              "mcps": []
            }
          }
        },
        "council": {
          "default_preset": "default",
          "presets": {
            "default": {
              "alpha": { "model": "opencode/big-pickle" },
              "beta": { "model": "opencode/space-bunny-free", "variant": "high" }
            }
          }
        }
      }
    '';
  };

  # TUI 插件：当前未启用任何 TUI 插件（原 @andre-barbosa/opencode-commit 提供 /commit
  # 斜杠命令，已移除）。theme/animations 保持与 V2 首次启动自动生成的 cli.json 一致。
  xdg.configFile."opencode/cli.json" = {
    force = true;
    text = ''
      {
        "$schema": "https://opencode.ai/v2/cli.json",
        "theme": {
          "mode": "light"
        },
        "animations": true
      }
    '';
  };

  # 声明 sops 机密（加密存储于 sops/secrets.yaml，由 sops-nix 在 activation 时解密）
  sops.secrets.opencode-server-password = { };

  # V2 的 serve 口令只认环境变量 OPENCODE_PASSWORD（用户名硬编码为 opencode，
  # 不可配置）。systemd 的 EnvironmentFile 要求 KEY=value 格式，而 sops 机密文件
  # 只有裸值，故用 sops.templates 渲染成 env 文件（凭据经 sops.placeholder 注入，
  # 明文不落 nix store）。
  sops.templates."opencode2-serve-env" = {
    content = ''
      OPENCODE_PASSWORD=${config.sops.placeholder.opencode-server-password}
    '';
  };

  # opencode server 用户级服务。开机自启依赖系统侧 linger（system/default.nix），
  # 挂在 default.target.wants，故无图形会话也启动；4096 已在
  # system/base/networking.nix 对全网放行，认证方式是 Basic（用户名为 opencode）。
  #
  # 注意：不要照抄 ddns-go/xray 的 ProtectHome/ProtectSystem 加固——serve 需要在用户
  # 家目录读写会话数据库与缓存，还要执行任意 shell 命令，收紧后必然不可用。
  systemd.user.services.opencode2-serve = {
    Unit = {
      Description = "opencode 2 server (Basic Auth)";
      After = [
        "network-online.target"
        # 需要 sops-nix.service 先渲染出口令 env 文件，否则 EnvironmentFile 缺失会启动失败
        "sops-nix.service"
      ];
      Requires = [ "sops-nix.service" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${opencode2}/bin/opencode2 serve --hostname :: --port 4096";
      EnvironmentFile = envFile;
      # 二进制由 nix 管理，自更新检查只会白跑网络请求
      Environment = [ "OPENCODE_DISABLE_AUTOUPDATE=true" ];
      Restart = "always";
      RestartSec = 5;
      NoNewPrivileges = true;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
