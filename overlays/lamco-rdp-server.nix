{
  lib,
  fetchurl,
  rustPlatform,
  pkg-config,
  cmake,
  nasm,
  clang,
  perl,
  python3,
  makeWrapper,
  openssl,
  pam,
  pipewire,
  fuse3,
  dbus,
  libxkbcommon,
  openh264,
}:

rustPlatform.buildRustPackage rec {
  pname = "lamco-rdp-server";
  version = "1.4.5";

  # 官方 release 源码包自带 vendor/ 和 .cargo/config.toml，可离线构建。
  src = fetchurl {
    url = "https://github.com/lamco-admin/lamco-rdp-server/releases/download/v${version}/lamco-rdp-server-${version}.tar.xz";
    hash = "sha256-v45IGmVbDWmtdwlJox6ECwBpFmqoeo8U04Ih74l6qL0=";
  };

  # 源码包根目录已经包含 vendor/，让 cargo setup hook 使用现有的
  # .cargo/config.toml；不要再生成/覆盖一份 cargoDeps。
  cargoVendorDir = ".";

  buildNoDefaultFeatures = true;
  # 面向 niri/wlroots 的原生后端：wlr 截屏/输入、wl-clipboard、NLA/CredSSP
  # 静态凭据、H.264 软件编码。pam-auth 特性保留以便切换认证后端，本机不使用；
  # GUI 不参与服务运行，故不启用 gui。
  buildFeatures = [
    "pam-auth"
    "h264"
    "wayland"
    "wl-clipboard"
    "portal-generic"
    "libei"
    "opus-libopus"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    nasm
    clang
    perl
    python3
    makeWrapper
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    pam
    pipewire
    fuse3
    dbus
    libxkbcommon
  ];

  # 测试需要真实的 Wayland/PipeWire 会话，不在 Nix 构建沙箱内运行。
  doCheck = false;

  postInstall = ''
    # OpenH264 是运行时 dlopen 加载的，必须把库目录加入 LD_LIBRARY_PATH。
    wrapProgram $out/bin/lamco-rdp-server \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ openh264 ]}

    install -Dm644 packaging/systemd/app-io.lamco.rdp-server.service \
      $out/lib/systemd/user/app-io.lamco.rdp-server.service
  '';

  meta = {
    description = "Wayland-native RDP server for Linux desktop sharing";
    homepage = "https://github.com/lamco-admin/lamco-rdp-server";
    license = lib.licenses.unfree; # BUSL-1.1，非 OSI 自由许可证
    mainProgram = "lamco-rdp-server";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
