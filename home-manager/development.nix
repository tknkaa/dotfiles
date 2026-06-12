{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    # Languages & Compilers
    gcc
    go
    bun
    nodejs_24
    zig
    (rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" "rust-analyzer" ];
    })

    # Development tools
    openssl
    tree-sitter
    uv
    gh
    vscode
    fzf
    zoxide
    lazygit
    antigravity
    ollama
    stylua
    github-copilot-cli
    tfenv
    gnumake
    shopify-cli
    google-cloud-sql-proxy
    vim
    google-cloud-sdk
    gettext
    claude-code
    postgresql
    delta

    # to preview readme in local
    python3Packages.grip
  ];
}
