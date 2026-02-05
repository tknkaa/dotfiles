{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      clang-tools
      lua-language-server
      pyright
      rPackages.languageserver
      gopls
      nixd
      gleam
      rust-analyzer
      tinymist
      zls

      nodePackages.typescript-language-server
      nodePackages.svelte-language-server
    ];
    initLua = builtins.readFile ./init.lua;
  };
}
