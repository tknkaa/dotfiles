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

      nodePackages.typescript-language-server
      nodePackages.svelte-language-server
      typescript
    ];
    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
