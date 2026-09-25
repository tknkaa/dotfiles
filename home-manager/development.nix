{ pkgs, config, inputs, ... }:
{
  home.packages = with pkgs; [
    inputs.hunk.packages.${pkgs.system}.default
    inputs.herdr.packages.${pkgs.system}.default
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
    antigravity-ide
    antigravity-cli
    ollama
    stylua
    github-copilot-cli
    tfenv
    gnumake
    shopify-cli
    google-cloud-sql-proxy
    vim
    google-cloud-sdk
    azure-cli
    gettext
    claude-code
    codex
    postgresql
    delta
    turso-cli
    sqld
    awscli2
    cursor-cli

    # to preview readme in local
    python3Packages.grip
  ];
}
