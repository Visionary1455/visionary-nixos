# Neovim + C/C++ 开发环境
#
# 插件全部来自 nixpkgs 的 pkgs.vimPlugins，由 flake.lock 锁定版本，不使用 lazy.nvim
# （nix-community/neovim-flake 与 folke/lazy.nvim 自带的 flake 均已停止维护）。
# 这里只声明「装哪些插件」，插件配置全部写在 dotfile/.config/nvim 的 Lua 里。
#
# 关键点：插件以裸包名形式声明（不写 config），并且开启 sideloadInitLua，
# 使 home-manager 不向 ~/.config/nvim 写入任何文件，该目录完全由 dotfile 镜像控制。
{
  pkgs,
  dotfile_dir,
  ...
}:
let
  vimPlugins = pkgs.vimPlugins;

  # treesitter 语法：由 nixpkgs 编译为 parser/<lang>.so，随插件进入 runtimepath，
  # 无需 vim.treesitter.language.add 手动注册，也不会触发 nvim 联网下载。
  grammar = name: vimPlugins.nvim-treesitter-parsers.${name};

  # nvim-treesitter（master）把官方语言的查询放在插件内的 runtime/queries/<lang>/，
  # 而 nvim 只在 runtimepath 上按 queries/<lang>/ 查找——插件目录下的 runtime/
  # 不会自动加入 rtp，于是「parser 在、查询不在」：高亮器能启动却匹配不到任何
  # 节点，表现就是纯文本无高亮，且不报任何错。nixpkgs 又刻意不给官方语言安装
  # 查询（neovim/utils.nix 的 installQueries = !isNvimGrammar，注释仍按旧版
  # 布局假设查询随插件发布），所以这里补一个相对软链把查询暴露到插件根部，
  # 与 parser/ 一样直接可被 rtp 找到。改用相对路径，store 复制后依然有效。
  nvimTreesitter = vimPlugins.nvim-treesitter.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      ln -sfn runtime/queries $out/queries
    '';
  });
in
{
  programs.neovim = {
    enable = true;

    # 让 git 等外部工具默认调用 nvim（仅写入用户会话变量，不影响系统环境）
    defaultEditor = true;

    # home-manager 默认会把 provider 桩代码写进 ~/.config/nvim/init.lua，
    # 与本模块镜像整个 nvim 目录的做法冲突；改为经 wrapper 参数注入，
    # 从而保证 ~/.config/nvim 只由 dotfile 决定。
    sideloadInitLua = true;

    # 注入到 nvim wrapper 的 PATH 后缀，保证 LSP、格式化、查找、调试器都能被找到
    extraPackages = with pkgs; [
      clang-tools
      cmake
      ninja
      lldb
      fzf
      ripgrep
      fd
      git
      which
      gnumake
    ];

    plugins = with vimPlugins; [
      # --- 基础依赖（其他插件会 require 它们，必须先加载）---
      plenary-nvim
      nui-nvim
      nvim-web-devicons

      # --- 主题 ---
      catppuccin-nvim

      # --- 语法解析：仅启用 C/C++/CMake，不装无关语言 ---
      nvimTreesitter
      (grammar "c")
      (grammar "cpp")
      (grammar "objc")
      (grammar "cmake")

      # --- 语言服务器 ---
      nvim-lspconfig

      # --- 补全 ---
      blink-cmp
      blink-nerdfont-nvim

      # --- 文件查找与文件树 ---
      telescope-nvim
      telescope-fzf-native-nvim
      neo-tree-nvim

      # --- 调试 ---
      # 刻意不装 nvim-dap-lldb：它的 setup() 只支持 codelldb 的 `--port` 回连架构，
      # 而本机用 pkgs.lldb 自带的 lldb-dap（stdio 直连 DAP），适配器在 Lua 里手写。
      nvim-dap
      nvim-dap-ui

      # --- 界面增强 ---
      which-key-nvim
      gitsigns-nvim
      bufferline-nvim
      lualine-nvim
      noice-nvim
      trouble-nvim
    ];
  };

  # Lua 配置整体从 dotfile 镜像到 ~/.config/nvim（软链接，仓库内修改即生效）
  home.file.".config/nvim" = {
    source = dotfile_dir + "/.config/nvim";
    recursive = true;
  };
}
