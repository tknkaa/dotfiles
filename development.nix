{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gcc
    go
    bun
    zig
    rust-bin.stable.latest.default
  ];
}
