# AGENTS.md

单主机 NixOS flake（`visionary-computer`，用户 `visionary`）。代码注释惯例使用简体中文。

## 构建与格式化

- 部署：
  ```bash
  sudo nixos-rebuild switch --flake .
  ```
- 格式化：`nix fmt`（formatter 是 `nixfmt`，不是 nixfmt-rfc-style）。
- 纯语法检查：`nix flake check --no-build` 会求值整个系统配置，较慢但不需要 root。

## 目录结构

- `host/` — 主机级配置：`configuration.nix`（nixos-hardware GPU/CPU 模块、xrdp、禁用睡眠）、`hardware-configuration.nix`（自动生成，勿手改）。
- `module/system/` — NixOS 模块。flak 中通过 `./module/system` 目录导入，实际聚合入口是 `module/system/default.nix`：新增/启用模块在此集中 `imports`，禁用一律用注释，不要删除文件。
- `module/hm/` — home-manager 模块（`users.visionary = ./module/hm`），聚合入口 `module/hm/default.nix`。
- `dotfile/` — 镜像用户主目录的原始文件。模块通过 specialArg `dotfile_dir` 引用，例：`source = dotfile_dir + /.config/kitty/kitty.conf`。
- `overlays/` — **不是 nixpkgs overlay**，是 `callPackage` 风格的包派生，用 `pkgs.callPackage ../../../overlays/xxx.nix {}` 引入（见 `sddm.nix`）。

## 易错点

- nixpkgs 稳定分支为 `nixos-26.05`；内核 `linuxPackages_7_1`（`module/system/nixos/bootloader.nix`）与 opencode（`module/system/default.nix`）来自 `nixpkgs-unstable`。引用 unstable 包统一用 `inputs.nixpkgs-unstable.legacyPackages.<system>`。
- 自定义 `mutable` 选项（`module/hm/base/mutable.nix`）：`mutable = true` 的文件被复制而非软链接，且**必须同时 `force = true`**；从配置移除后目标文件不会自动删除。
- 用户级服务自启依赖 `users.users.visionary.linger = true`（`module/system/default.nix`）：`ddns-go`、`sops-nix`、`xray` 挂在 `default.target.wants`（无图形会话也启动）；`wayvnc` 挂在 `graphical-session.target.wants`，**不**依赖 linger。日志用 `journalctl --user -u ddns-go -f`。
- 本机凭据由 **sops-nix** 管理：加密存储于仓库内 `sops/secrets.yaml`（可安全入库），age 私钥位于 `~/.config/sops/age/keys.txt`（已 gitignore，严禁入库）。模块通过 `sops.templates` + `sops.placeholder` 在 activation 阶段注入凭据生成最终配置，无需 `--impure`。添加/修改凭据：编辑明文后用 `sops -e -i sops/secrets.yaml` 加密，然后 rebuild。不要把真实密钥写进任何 `.nix` 文件或提交进 git。
- `module/system/default.nix` 中的 `vscodeCdnUrl`（微软 CDN 绕墙）在 VSCode 升级后 commit/build 号会变，需要同步更新，hash 由 nixpkgs 记录。
- 实际桌面为 niri（hyprland 已注释禁用）；SDDM 默认会话 `niri`，XWayland 由 `xwayland-satellite` 提供（X11 应用依赖）。
- 全局规则 `~/.config/opencode/AGENTS.md` 由 `module/hm/program/opencode.nix` 生成（始终使用简体中文回复）。opencode server 需**手动**执行 `opencode serve --hostname :: --port 4096` 启动，仓库里**没有**对应的声明式 systemd 单元（别去找）。`--hostname ::` 会监听所有接口，而 4096 已在 `module/system/base/networking.nix` 的 `allowedTCPPorts` 里对全网放行，因此**必须启用 Basic Auth**；口令自定义，不要写进本文件或提交进 git。
- opencode 插件由 `module/hm/program/opencode.nix` 声明式配置：server 插件（`oh-my-opencode`、`opencode-browser`）写在 `opencode.jsonc`，TUI-only 插件（`@andre-barbosa/opencode-commit`，即 `/commit` 斜杠命令，model 为 `opencode/deepseek-v4-flash-free`）必须写在 `tui.jsonc`。npm 插件由 opencode 启动时自动安装到 `~/.cache/opencode/node_modules`，不经过 nix store；`opencode-browser` 依赖 Browser MCP（`npx -y @browsermcp/mcp@0.1.3`，由 home.packages 的 `nodejs` 提供 npx），还需在浏览器中安装 Browser MCP 扩展。
- **编辑器统一为 neovim，无 vim/vi 兼容命令**：经典 `vim` 已从 `environment.systemPackages` 移除（`module/system/default.nix`）；`nvim` 由 home-manager 的 `programs.neovim` 提供，只在用户会话 PATH（`/etc/profiles/per-user/<user>/bin`）里，不在系统 PATH。别把 `vim` 加回来"顺手"——`xxd` 本是 vim 包的 propagated output，删 vim 会连带把它从系统 PATH 带走，故显式保留了 `vim.xxd`（该输出只有 `bin/xxd`，与 vim 命令无关）。
- **`$EDITOR` 在 fish 里不会自动生效**：`programs.neovim.defaultEditor = true` 只生成 `…/etc/profile.d/hm-session-vars.sh`（内含 `EDITOR=nvim`），但 **fish 不读 POSIX 的 `profile.d`**；且本机 `programs.fish.enable` 在 NixOS 侧（`module/system/program/shell.nix`）而非 home-manager 侧，home-manager 的 `hm-session-vars.fish` 桥接因此根本不会生成。所以 `EDITOR`/`VISUAL` 必须在 `dotfile/.config/fish/config.fish` 里 `set -gx`。另外登录时 systemd user env 里可能残留陈旧 `EDITOR`（本机曾是 `nano`），`environment.d` 只在登录时导入，新值要重新登录才进 systemd。
- **yazi 配置段名是 `[mgr]` 不是 `[manager]`**：`module/hm/program/yazi.nix` 的 `settings` 由 home-manager 原样生成 `~/.config/yazi/yazi.toml`（yazi 26.x 已从 `config.toml` 改名）。26.x 丢弃了 `[manager]` 这个旧段名，**写错不报错、整段被静默丢弃**（home-manager 的 option 示例里也是 `mgr`）。yazi 默认的 `edit` opener 是 `${EDITOR:-vi} %s`，`$EDITOR` 一旦为空就退回 `vi`；该模块已显式写 `nvim %s` 而不依赖环境变量。校验配置可对照官方 schema `https://yazi-rs.github.io/schemas/yazi.json`。

## Neovim / C++ 开发环境

- `module/hm/program/neovim.nix` 用 `programs.neovim` + `pkgs.vimPlugins` 声明 23 项（19 个插件 + 4 个 treesitter 语法），Lua 配置镜像自 `dotfile/.config/nvim/`。**不要引入 lazy.nvim**：`nix-community/neovim-flake` 已 404，`folke/lazy.nvim` 与 `LazyVim` 的 flake.nix 也已被移除；home-manager release-26.05 的 `programs.neovim` 更已移除 `lsp`/`format`/`keymaps` 等子模块。
- **`~/.config/nvim` 归 dotfile 管**：模块开了 `sideloadInitLua = true`，home-manager 不再写 `init.lua`（否则会与目录软链接冲突报 collision）。因此插件**只能以裸包名声明，不能加 `config = ...`**，插件配置全写在 Lua 里。
- 插件属性名带 `-nvim` 后缀：`conform-nvim`、`which-key-nvim`、`gitsigns-nvim`、`nui-nvim`、`blink-nerdfont-nvim`、`telescope-fzf-native-nvim`。treesitter 语法是 `vimPlugins.nvim-treesitter-parsers.<lang>` 的**属性集**（329 个语言），不是包。
- **treesitter 高亮需要的是查询（queries），不只是 parser**：nvim-treesitter（master）把官方语言的查询放在插件内的 `runtime/queries/<lang>/`，但 nvim 只在 runtimepath 上按 `queries/<lang>/` 查找，插件目录下的 `runtime/` **不会**自动进 rtp。nixpkgs 又刻意不给官方语言装查询（`neovim/utils.nix` 的 `installQueries = !isNvimGrammar`，注释还按旧版布局假设"查询随插件发布"），于是「parser 在、查询不在」：`vim.treesitter.highlighter.active[buf]` 是 true、`vim.treesitter.start()` 也不报错，但零捕获 → 纯文本无高亮。`neovim.nix` 里已用 `overrideAttrs` 补 `ln -sfn runtime/queries $out/queries`。**`c` 是假阳性**：nvim 核心自带 `runtime/queries/c/`，所以 C 文件正常而 `cpp`/`cmake` 坏掉，别被"C 能高亮"误导。查询随 nvim-treesitter 升级而变，升级后要重新验证。
- C/C++ 工具链在 `module/system/program/cpp.nix`（系统级）。注意 **`clang-tools` 不含 `clang`/`clang++`**，编译器要单独声明；`lldb-dap` 由 `pkgs.lldb` 提供（nixpkgs 无 `codelldb`）。
- `extraPackages` 决定 nvim wrapper 的 PATH 后缀，`clangd`/`clang-format`/`lldb-dap`/`fzf` 都要靠它才能被找到；新增依赖外部二进制的插件时同步加进去。
- clangd 没有 `compile_commands.json` 会退回启发式模式；`dotfile/.config/nvim/lua/plugins/lsp.lua` 的 `find_compile_commands` 定位后传 `--compile-commands-dir`，重新生成数据库后用 `:ClangdSetDb` 刷新。**查找必须同时看常见构建子目录**：CMake 默认把数据库写在 `build/` 里，只逐级向上找是找不到的。向上查找仍需防 `/` 死循环（父目录等于自身时返回 nil）。
- clangd 的编译数据库**只在启动时按 cwd 求值一次**是不够的：从工程目录之外启动 nvim 时首屏拿不到它。`lsp.lua` 因此在打开 C/C++ 文件时（`BufReadPost`/`BufNewFile`）按该缓冲区重算，目录变化才重启客户端，避免每次切文件重建索引。
- 新增文件后 `nix flake check` 会报 "path does not exist"：未提交的文件不在 git 快照里，用 `nix flake check path:. --no-build --impure` 求值。
- **插件配置有静默回退，不报错但没生效**：catppuccin 2.0 的 lualine 主题按 flavour 分别导出（`catppuccin-mocha` 等），写 `theme = 'catppuccin'` 会静默回退 `auto`；lualine 的 `extensions` 只接受扩展名（`nvim-tree`、`neo-tree`），`nvim-tree/indent` 这种"扩展/组件"写法会触发 `Invalid filename` 断言失败。排查这类问题用 `:lua require('lualine.utils.notices').show_notices()`——notice 存在模块内的 local 变量里，`LualineNotices` 命令在 headless 下不一定已注册。
- **写补全测试时别断言 label 的原始前缀**：clangd 返回的 `CompletionList` 里，非精确前缀匹配的候选项 label 会带一个**前导空格**（如输入 `gr` 得到 `" greet"`，`kind=3`），用于让客户端区分模糊匹配；断言必须 `vim.trim` 后再比对，否则会误判"补全没生效"。另外两点：clangd 返回的是 `CompletionList`（`{items=..., isIncomplete=...}`）而非 `CompletionItem[]`，直接对 `result` 取 `#` 恒为 0，要先取 `result.items`；改完缓冲区立刻发 `textDocument/completion` 会拿到 `didChange` 之前的结果，需先用轻量请求轮询确认 clangd 已同步。
- **headless 下测不了高亮是否真的上色**：`nvim --headless` 没有 UI 附着就不执行 redraw，高亮器不会应用任何 extmark，所以 `get_captures_at_cursor()` 和 `nvim_buf_get_extmarks()` 对**正常高亮**的文件同样返回空——不能用来判断"高亮有没有生效"。可靠做法是数查询实际匹配的捕获数：`vim.treesitter.query.get(ft, 'highlights')` 为 `nil` 就是没有查询（高亮必然失效），再用 `q:iter_captures(tree:root(), buf, 0, -1)` 数个数；或直接看 `:checkhealth vim.treesitter` 的 "Treesitter queries" 段。另外 `packloadall` 对已经被自动加载过的包不会重新加载，模拟"换了一套 generation"必须**替换** `packpath`（`--cmd 'set packpath=...'`），用 `^=` 追加会被旧 pack 抢先。
