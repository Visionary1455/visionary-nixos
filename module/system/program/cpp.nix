# C/C++ 开发工具链
# 编译器、构建系统与调试器，系统级安装，任意编辑器与终端都能直接使用。
# 注意：clangd 需要与 clang 同版本的运行时，因此整组工具统一取自 nixpkgs 的 LLVM。
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    # 编译器：clang / clang++（clang-tools 不含编译器本体，需单独声明）
    clang

    # LLVM 工具链：clangd（LSP）/ clang-format / clang-tidy
    clang-tools

    # 构建工具：CMake 配合 Ninja 生成 compile_commands.json，clangd 依赖它获取
    # 真实的宏定义、include 路径与 C++ 标准；gnumake 用于传统 Makefile 工程
    cmake
    ninja
    gnumake

    # LLDB 调试器：其自带的 lldb-dap 是 nvim-dap 的 C/C++ 调试适配器（见 module/hm/program/neovim.nix）
    lldb
  ];
}
