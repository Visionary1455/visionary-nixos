# 主机与用户身份集中定义。
# 修改主机名、架构、用户名或状态版本时只需改这一处；flake 输出、
# NixOS 模块与 Home Manager 均从这里取值。
{
  hostname = "visionary-computer";
  system = "x86_64-linux";
  username = "visionary";
  stateVersion = "26.05";
}
