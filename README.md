# visionary-nixos

单主机 NixOS Flake 配置，主机名 `visionary-computer`，用户 `visionary`，架构 `x86_64-linux`。
系统级配置与用户级配置（home-manager）统一声明式管理，所有注释使用简体中文。

## 特性

- **桌面环境**：niri（Wayland 平铺合成器）+ Noctalia shell（状态栏/Dock/锁屏/控制中心）+ SDDM（Qt6 + Candy 主题，kwin 合成器，默认会话 niri）
- **输入法**：fcitx5（Wayland 前端，云拼音百度源，含萌娘百科/中文维基词库 overlay）
- **终端与 Shell**：kitty + fish + starship（Catppuccin 主题）
- **文件管理**：Dolphin（GUI，含 ark/KIO 全家桶）+ yazi（终端 TUI，带 PDF/视频/图片/压缩包预览）
- **开发工具**：VSCode（Wayland IME + 微软 CDN 绕过）、opencode（AI 助手，常驻 server 服务）、全套 LSP（nix/nil、gopls、zls、typescript、lua、python 等）
- **网络与远程**：NetworkManager、tailscale（子网路由）、OpenSSH、xrdp 远程桌面、v2ray/v2rayN（XWayland）
- **服务**：ddns-go（阿里云 DDNS，IPv4/IPv6 双栈）、opencode server（端口 4096）
- **硬件与系统**：nixos-hardware CPU/GPU 模块、PipeWire 音频、蓝牙（overskride）、硬件视频加速（Intel VAAPI）、禁用睡眠
- **游戏**：Steam（gamescope 会话）+ Lutris + MangoHud
- **Nix 优化**：清华/USTC 镜像源、自动 GC（14 天）、每周自动升级、500MB 下载缓冲、`auto-optimise-store`

## 快速开始

部署/重建（必须带 `--impure`，原因见下方[注意事项](#注意事项)）：

```bash
sudo nixos-rebuild switch --impure --flake .
```

纯语法检查（求值整个系统配置，不需要 root）：

```bash
nix flake check --no-build --impure
```

格式化（formatter 为 `nixfmt`）：

```bash
nix fmt
```

> 注意：`nix fmt` 在当前 Nix 版本（≥2.24）下不会自动发现文件，需要显式传文件列表，例如 `nix fmt $(git ls-files '*.nix')`。

## 目录结构

```
├── flake.nix                    # flake 入口：inputs、system、specialArgs
├── host/
│   ├── configuration.nix        # 主机级配置：硬件模块、xrdp、禁用睡眠、用户组
│   └── hardware-configuration.nix  # 自动生成，勿手改
├── module/
│   ├── system/                  # NixOS 模块（聚合入口 default.nix）
│   │   ├── base/                # 基础：网络、蓝牙、音频、输入法、游戏、硬件
│   │   ├── nixos/               # bootloader、nix 设置、GC、自动升级、字体
│   │   ├── displaymanager/      # SDDM
│   │   └── program/             # niri、shell、LSP、虚拟化、Flatpak 等
│   └── hm/                      # home-manager 模块（users.visionary）
│       ├── base/                # mutable 文件扩展、XDG、Qt 主题
│       └── program/             # 各程序配置：bat、dolphin、yazi、opencode 等
├── dotfile/                     # 镜像用户主目录的原始文件（通过 specialArg dotfile_dir 引用）
├── overlays/                    # callPackage 风格包派生（非 nixpkgs overlay）
└── AGENTS.md                    # 开发指南与易错点
```

## 模块说明

### module/system（NixOS 侧）

| 文件 | 说明 |
| --- | --- |
| `nixos/bootloader.nix` | systemd-boot、unstable 内核 `linuxPackages_7_1`、启动条目上限 8 |
| `nixos/nix.nix` | flake 实验特性、清华/USTC 镜像、GitHub token 引入、GOPROXY |
| `nixos/gc.nix` | 每周自动 GC（保留 14 天）、自动优化 store |
| `nixos/auto-upgrade.nix` | 每周自动升级并更新 flake.lock |
| `nixos/fonts.nix` | Noto + Nerd Fonts 全家桶 |
| `base/networking.nix` | NetworkManager、防火墙放行 4096 |
| `base/tailscale.nix` | tailscale server 模式、宣告 `192.168.0.0/24` 子网路由 |
| `base/open-ssh.nix` | OpenSSH，仅允许 visionary 用户 |
| `base/opengl.nix` | 硬件图形加速（32 位 + Intel VAAPI/NVDEC 驱动） |
| `base/audio.nix` | PipeWire + WirePlumber + 蓝牙音频工具 |
| `base/bluetooth.nix` | 蓝牙（关闭开机自启）、overskride |
| `base/fcitx5.nix` | fcitx5 输入法 + 中文字体优化 + 区域设置 |
| `base/gaming.nix` | Steam、Lutris、Gamescope、MangoHud |
| `base/hardware.nix` | 亮度、外设挂载、NTFS/exFAT、传感器工具 |
| `displaymanager/sddm.nix` | Qt6 SDDM + Candy 主题 + kwin 合成器 + Bibata 光标 |
| `program/niri.nix` | niri 本体 + xwayland-satellite（v2rayN 等 X11 应用依赖） |
| `program/shell.nix` | fish（默认 shell）+ 插件（fzf、hydro、forgit、grc） |
| `program/lsp.nix` | 全套语言服务器 |
| `program/dms.nix` | DankMaterialShell（默认禁用） |
| `program/flatpak-module.nix` | Flatpak + 国内镜像（默认禁用） |
| `program/virtualization.nix` | Docker + libvirt/QEMU 虚拟化（默认禁用） |

### module/hm（home-manager 侧）

| 文件 | 说明 |
| --- | --- |
| `base/mutable.nix` | 自定义 `mutable` 选项：可写文件复制而非软链接 |
| `base/xdg.nix` | XDG 基目录与用户目录、Portal、mime 应用 |
| `base/qt.nix` | Qt5/Qt6 主题（qt5ct/qt6ct/Kvantum）、Colloid 图标、Nerd Fonts |
| `program/git.nix` | Git 全局配置 |
| `program/bat.nix` | bat（带语法高亮的 cat） |
| `program/shell.nix` | starship 提示符、fish 配置（`rebuild` 命令） |
| `program/terminals.nix` | kitty 终端（含 wallbash 主题） |
| `program/dolphin.nix` | Dolphin + ark 压缩集成 + KDE 主题，目录默认打开器 |
| `program/yazi.nix` | yazi 终端文件管理器 + 预览依赖（PDF/视频/图片/压缩包） |
| `program/fastfetch.nix` | 系统信息展示（含 logo） |
| `program/firefox.nix` | Firefox（Wayland）+ userChrome/user.js + 扩展 |
| `program/niri.nix` | niri 的 config.kdl（内联管理） |
| `program/noctalia.nix` | Noctalia shell 全量配置 |
| `program/ddns-go.nix` | ddns-go 用户级服务 + 配置（凭据从仓库外 CSV 注入） |
| `program/opencode.nix` | opencode 配置（server/TUI 插件、AGENTS.md） |

### overlays（包派生）

| 文件 | 说明 |
| --- | --- |
| `sddm-candy.nix` | Candy 主题，已适配 Qt6（Qt5Compat.GraphicalEffects） |
| `Bibata-Modern-Ice.nix` | 鼠标光标主题 |
| `fcitx5-pinyin-moegirl.nix` / `fcitx5-pinyin-zhwiki.nix` | fcitx5 中文词库 |

## 新增或修改模块

1. 在 `module/system/` 或 `module/hm/` 下新建 `.nix` 文件
2. 在对应的聚合入口注册：
   - 系统模块 → `module/system/default.nix` 的 `imports`
   - 用户模块 → `module/hm/program/default.nix` 的 `imports`
3. 禁用模块一律**注释掉** import 行，不要删除文件
4. 需要引用 `dotfile/` 下的文件时，使用 specialArg `dotfile_dir`：
   ```nix
   home.file.".config/xxx/yyy" = {
     source = dotfile_dir + /.config/xxx/yyy;
   };
   ```

## 常用命令

```bash
# 部署
sudo nixos-rebuild switch --impure --flake .

# 查看系统代数并回滚
sudo nixos-rebuild list-generations
sudo nixos-rebuild switch --rollback

# GC
sudo nix-collect-garbage -d

# ddns-go 用户级服务日志
journalctl --user -u ddns-go -f

# opencode server（端口 4096）
journalctl --user -u opencode-server -f
```

## 注意事项

- **必须 `--impure` 部署**：`module/hm/program/ddns-go.nix` 用 `builtins.readFile` 读取仓库外的 `~/.config/ddns-go/AccessKey.csv`，纯模式下 flake 求值会报 "absolute path forbidden"。
- **AccessKey 保密**：阿里云密钥只存在 `~/.config/ddns-go/AccessKey.csv`（格式：`AccessKey ID,AccessKey Secret`），不要写进任何 `.nix` 文件。
- **unstable 引用**：内核与 opencode 来自 `nixpkgs-unstable`，引用统一用 `inputs.nixpkgs-unstable.legacyPackages.<system>`。
- **`mutable` 文件**：`mutable = true` 的文件被复制而非软链接，且**必须同时 `force = true`**；从配置移除后目标文件不会自动删除。
- **linger**：用户级服务（ddns-go、opencode-server）开机自启依赖 `users.users.visionary.linger = true`。
- **vscodeCdnUrl**：VSCode 升级后 CDN URL 的 commit/build 号会变，需在 `module/system/default.nix` 中同步更新。
- **XWayland**：niri 25.08+ 无内嵌 XWayland，由 `xwayland-satellite` 提供，v2rayN 等 X11 应用依赖。
- **硬件配置**：`host/hardware-configuration.nix` 由 `nixos-generate-config` 自动生成，勿手改。

## 输入源

| 输入 | 来源 | 分支 |
| --- | --- | --- |
| nixpkgs | `github:nixos/nixpkgs` | `nixos-26.05` |
| nixpkgs-unstable | `github:NixOS/nixpkgs` | `nixos-unstable` |
| home-manager | `github:nix-community/home-manager` | `release-26.05` |
| nixos-hardware | `github:NixOS/nixos-hardware` | `master` |
| noctalia | `github:noctalia-dev/noctalia-shell` | — |
| quickshell / dms | outfoxxed / AvengeMedia | — |
| nix-index-database | `github:nix-community/nix-index-database` | — |
