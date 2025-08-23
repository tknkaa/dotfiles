{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gcc
    go
    nodejs-slim # npmのないNode.js単体
    nodePackages.pnpm
    nodePackages.wrangler
    deno
    bun
    python312
    zig
    rust-bin.stable.latest.default
    pnpm
  ];
}
