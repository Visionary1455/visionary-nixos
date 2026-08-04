{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    python312Packages.python-lsp-server
    nodemon
    typescript
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server
    dockerfile-language-server
    bash-language-server
    graphql-language-service-cli
    vue-language-server
    lua-language-server
    marksman
    markdown-oxide
    nil
    zls
    gopls
    delve
    emmet-language-server
    buf
    cmake-language-server
    docker-compose-language-service
    vscode-extensions.vadimcn.vscode-lldb
    slint-lsp
    terraform-ls
    #ansible-language-server
    hyprls
  ];
}
