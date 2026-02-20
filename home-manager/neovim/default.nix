{ pkgs, inputs, ... }:
{
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      clang-tools
      lua-language-server
      pyright
      rPackages.languageserver
      gopls
      nixd
      gleam
      tinymist
      zls

      nodePackages.typescript-language-server
      nodePackages.svelte-language-server

      inputs.rustowl-flake.packages.${pkgs.system}.rustowl
      inputs.rustowl-flake.packages.${pkgs.system}.rustowl-nvim


      rust-bin.nightly.latest.default
    ];
    initLua = builtins.readFile ./init.lua;
  };
}
