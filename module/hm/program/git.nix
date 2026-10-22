{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Enable fish
  home.packages = with pkgs; [
    git
  ];
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "visionary";
        email = "15282219250@163.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  # delta：语法高亮 + 左右分栏 diff
  # enableGitIntegration 会接管 git diff/log/show/blame 的分页器；
  # 仅设置 options 不会自动修改 Git 配置。
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
    };
  };

  # delta 0.19.x 只读取 ~/.gitconfig，而 Home Manager 把 Git 配置写在
  # ~/.config/git/config；只靠 enableGitIntegration 会让 delta 读不到
  # [delta] 选项并退回单栏。这里把同一份 options 同步到 ~/.gitconfig。
  home.file.".gitconfig".text = lib.generators.toGitINI {
    delta = config.programs.delta.options;
  };

  # TUI Git 客户端（终端内查看提交、分支、暂存与 diff）
  programs.lazygit = {
    enable = true;
    # lazygit 0.61.x 使用 pagers 数组；旧版 git.paging.pager 已不再使用。
    # lazygit 会把 pager 放进与补丁面板等宽的 PTY，delta 能直接读到真实宽度；
    # 不要传 --width={{columnWidth}}：该占位符是半宽，会让补丁只占面板一半。
    settings.git.pagers = [
      { pager = "delta --paging=never --side-by-side"; }
    ];
  };
}
