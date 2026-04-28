{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
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

      typescript-language-server
      svelte-language-server
      vue-language-server
    ];
    initLua = builtins.readFile ./init.lua;
  };
}
