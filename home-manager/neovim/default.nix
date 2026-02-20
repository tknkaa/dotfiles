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
      tinymist
      zls
      rustowl

      nodePackages.typescript-language-server
      nodePackages.svelte-language-server
    ];
    initLua = builtins.readFile ./init.lua;
  };
}
