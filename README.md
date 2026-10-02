# visionary-nixos

单主机 NixOS Flake 配置，主机名 `visionary-computer`，用户 `visionary`，架构 `x86_64-linux`。
系统级配置与用户级配置（home-manager）统一声明式管理，所有注释使用简体中文。

## 特性

- **桌面环境**：niri（Wayland 平铺合成器）+ Noctalia shell（状态栏/Dock/锁屏/控制中心）+ SDDM（Qt6 + Candy 主题，kwin 合成器，默认会话 niri）
- **输入法**：fcitx5（Wayland 前端，云拼音百度源，含萌娘百科/中文维基词库 overlay）
- **终端与 Shell**：kitty + fish + starship（Catppuccin 主题）
- **文件管理**：Dolphin（GUI，含 ark/KIO 全家桶）+ yazi（终端 TUI，带 PDF/视频/图片/压缩包预览）
- **开发工具**：VSCode（Wayland IME + 微软 CDN 绕过）、opencode（AI 助手，常驻 server 服务）、Neovim（clangd LSP + lldb-dap 调试 + clang-format）、全套 LSP（nix/nil、gopls、zls、typescript、lua、python 等）
- **网络与远程**：NetworkManager、tailscale（子网路由）、OpenSSH、xrdp 远程桌面、Clash Verge Rev（mihomo 内核，TUN 模式）
- **服务**：ddns-go（阿里云 DDNS，IPv4/IPv6 双栈）、opencode server（端口 4096）、xray（本地代理服务）
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
| `program/niri.nix` | niri 本体 + xwayland-satellite（X11 应用兼容） |
| `program/shell.nix` | fish（默认 shell）+ 插件（fzf、hydro、forgit、grc） |
| `program/lsp.nix` | 全套语言服务器 |
| `program/cpp.nix` | C/C++ 工具链：clang/clang++、clangd、clang-format、clang-tidy、cmake、ninja、gnumake、lldb |
| `program/dms.nix` | DankMaterialShell（默认禁用） |
| `program/flatpak-module.nix` | Flatpak + 国内镜像（默认禁用） |
| `program/virtualization.nix` | Docker + libvirt/QEMU 虚拟化（默认禁用） |
| `program/clash-verge.nix` | Clash Verge Rev（mihomo 内核，TUN 模式 + serviceMode + 自启动） |

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
| `program/chrome.nix` | chrome+ userChrome/user.js + 扩展 |
| `program/niri.nix` | niri 的 config.kdl（内联管理） |
| `program/neovim.nix` | Neovim + 插件（pkgs.vimPlugins，23 项 = 19 个插件 + 4 个 treesitter 语法）+ Lua 配置镜像到 `~/.config/nvim` |
| `program/noctalia.nix` | Noctalia shell 全量配置 |
| `program/ddns-go.nix` | ddns-go 用户级服务 + 配置（凭据从仓库外 CSV 注入） |
| `program/opencode.nix` | opencode 配置（server/TUI 插件、AGENTS.md） |
| `program/xray.nix` | xray 用户级服务（sops-nix 注入凭据，启动前 `-test` 校验） |

### overlays（包派生）

| 文件 | 说明 |
| --- | --- |
| `sddm-candy.nix` | Candy 主题，已适配 Qt6（Qt5Compat.GraphicalEffects） |
| `Bibata-Modern-Ice.nix` | 鼠标光标主题 |
| `fcitx5-pinyin-moegirl.nix` / `fcitx5-pinyin-zhwiki.nix` | fcitx5 中文词库 |

## Neovim C++ 开发环境

`nvim` 即为编辑器，`defaultEditor = true` 已让它成为 git 等外部工具的默认 `$EDITOR`。
Lua 配置在 `dotfile/.config/nvim/`，改完执行 `home-manager` 部署即生效（软链接，无需复制）。

### 开始一个 CMake 工程

```bash
mkdir -p ~/code/demo/src && cd ~/code/demo
cmake -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
nvim src/main.cpp
:ClangdSetDb   " 重新探测并重启 clangd（一般无需手动执行）
```

编译数据库生成后，clangd 才能正确解析宏、`include` 路径与 C++ 标准；
未生成时配置里的 `fallbackFlags = '-std=c++20'` 会兜底，但补全与重构质量明显下降。
查找时每一级目录既看自身，也看 `build/`、`out/` 等常见构建子目录，
因此 CMake 的 `build/compile_commands.json` 无需额外配置即可找到；
打开 C/C++ 文件时会按该文件重新定位，跨工程切换会自动刷新，
只有重新生成了编译数据库才需要手动执行 `:ClangdSetDb`。

### 主要键位（`<leader>` 与 `<localleader>` 均为空格）

| 键位 | 功能 |
| --- | --- |
| `<leader>ff` / `<leader>fg` / `<leader>fG` | 文件查找 / 工程内实时搜索 / 搜索光标下单词 |
| `<leader>fs` / `<leader>fsx` / `<leader>fsw` | 当前文件文本 / 当前文件符号 / 工程内符号 |
| `<leader>fb` / `<leader>fh` / `<leader>fk` / `<leader>fd` | 缓冲区 / 帮助 / 键位映射 / 诊断 |
| `<leader>e` / `<leader>ef` | 文件树切换 / 在文件树中定位当前文件 |
| `<leader>xx` 系列 | trouble 诊断列表（当前文件 / quickfix / telescope） |
| `<C-h/j/k/l>`、`<leader>w`、`<leader>v/s/o/q`、`<leader>=` | 窗口跳转与分屏（`<leader>w` 为 `<C-w>` 前缀） |
| `<leader>bd` | 关闭当前缓冲区 |
| `<leader>tn/tc/tp/tnx/tm` | 新建 / 关闭 / 上一个 / 下一个 / 移动标签页 |
| `]c` / `[c` | 在 Git 改动块之间跳转 |
| `<localleader>d` | 打开 dap-ui 调试面板 |
| `<localleader>b` / `B` / `c` / `n` / `i` / `o` | 断点 / 条件断点 / 继续 / 单步跳过 / 单步进入 / 单步跳出 |
| `<localleader>x` / `r` / `R` | 结束调试 / 重启 / 选择可执行文件调试 |
| `gd` / `gr` / `gi` / `K` | LSP 跳转定义 / 引用 / 实现 / 悬浮文档 |
| `<C-]>` / `<leader>rn` / `<leader>ca` / `<leader>ld` | LSP 跳转声明 / 重命名 / 快速修复 / 行内诊断详情 |

格式化由 clangd 在保存前完成（等价 `clang-format`，共用项目的 `.clang-format`），
也可手动执行 `:ClangdFormat`。若某个项目偏好格式化器而非保存时格式化，
删掉 `dotfile/.config/nvim/lua/plugins/format.lua` 中对应的 `BufWritePre` 即可。

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

# xray 用户级服务日志
journalctl --user -u xray -f
```

## 注意事项

- **必须 `--impure` 部署**：`module/hm/program/ddns-go.nix` 用 `builtins.readFile` 读取仓库外的 `~/.config/ddns-go/AccessKey.csv`，纯模式下 flake 求值会报 "absolute path forbidden"。
- **AccessKey 保密**：阿里云密钥只存在 `~/.config/ddns-go/AccessKey.csv`（格式：`AccessKey ID,AccessKey Secret`），不要写进任何 `.nix` 文件。
- **unstable 引用**：内核与 opencode 来自 `nixpkgs-unstable`，引用统一用 `inputs.nixpkgs-unstable.legacyPackages.<system>`。
- **`mutable` 文件**：`mutable = true` 的文件被复制而非软链接，且**必须同时 `force = true`**；从配置移除后目标文件不会自动删除。
- **linger**：用户级服务（ddns-go、opencode-server、xray）开机自启依赖 `users.users.visionary.linger = true`。
- **vscodeCdnUrl**：VSCode 升级后 CDN URL 的 commit/build 号会变，需在 `module/system/default.nix` 中同步更新。
- **XWayland**：niri 25.08+ 无内嵌 XWayland，由 `xwayland-satellite` 提供，X11 应用依赖。
- **硬件配置**：`host/hardware-configuration.nix` 由 `nixos-generate-config` 自动生成，勿手改。
- **Neovim 配置归属**：`~/.config/nvim` 整个目录由 `dotfile/.config/nvim` 软链接而来，home-manager 不会往里写文件（模块里开了 `sideloadInitLua`）。**不要给插件加 `config = ...`**，否则 home-manager 会重新启用 `init.lua` 写入并与目录软链接冲突。
- **Neovim 插件来源**：全部取自 `pkgs.vimPlugins`，属性名带 `-nvim` 后缀（`conform-nvim`、`which-key-nvim`、`gitsigns-nvim`…）。**没有用 lazy.nvim**：`nix-community/neovim-flake` 已 404、`folke/lazy.nvim` 与 `LazyVim` 的 flake.nix 均已移除。
- **clangd 依赖编译数据库**：没有 `compile_commands.json` 时 clangd 退回启发式模式，头文件解析与重构会失效。CMake 工程用 `cmake -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=ON` 构建。查找逻辑在 `lua/plugins/lsp.lua` 的 `find_compile_commands`：每一级目录既看自身，也看 `build/`、`out/` 等常见构建子目录（CMake 默认写在 `build/` 子目录里，只向上找是找不到的）。重新生成数据库后用 `:ClangdSetDb` 刷新。
- **treesitter 语法**：由 `vimPlugins.nvim-treesitter-parsers.<lang>` 提供（共 329 个），已装 `c`/`cpp`/`objc`/`cmake`。语法是 Nix 侧编译的 `.so`，nvim 不会联网下载，也**不要**调用 `vim.treesitter.language.add` 去装其它语言。**注意查询（queries）不随语法包提供**：nixpkgs 对官方语言刻意跳过 `queries/`，而查询实际在 nvim-treesitter 插件的 `runtime/queries/` 里（插件目录下的 `runtime/` 不在 rtp 上），所以 `neovim.nix` 用 `overrideAttrs` 补了 `ln -sfn runtime/queries $out/queries`。少了这一步的症状是"不报错的纯文本"：高亮器已启动但匹配不到任何节点。
- **图标（nvim-web-devicons）**：文件树、状态栏、LSP 符号与补全菜单的图标由 `nvim-web-devicons` 提供，在 `lua/config/options.lua` 中以 `vim.g.webdevicons = { default = true, NerdFont = true }` 显式开启 Nerd Font 变体。该设置**必须在插件加载前执行**（`options.lua` 是 `init.lua` 里最先执行的部分），否则图标会退回非 Nerd 字形。对应字形由 `nixos/fonts.nix` 安装，终端与 GUI 应用需选用 Nerd Font 字体才能显示，否则图标位置显示为空白方块。

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
