{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Languages & Compilers
    gcc
    go
    bun
    zig
    rust-bin.stable.latest.default

    # Nix tooling
    nixfmt-tree
    nil
    nixd

    # Development tools
    openssl
    conda
    uv
    gh
    github-copilot-cli
    vscode
  ];
}
