{ pkgs, rustowl, ... }:
{
  home.packages = with pkgs; [
    # Languages & Compilers
    gcc
    go
    bun
    zig
    (rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" "rust-analyzer" ];
    })

    # Development tools
    openssl
    conda
    uv
    gh
    github-copilot-cli
    vscode
    fzf
    zoxide
    lazygit
    antigravity
    qwen-code
    stylua

    rustowl # rustowl check
  ];
}
