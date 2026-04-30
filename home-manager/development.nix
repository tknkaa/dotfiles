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
    # to preview readme in local
    python3Packages.grip
  ];
}
