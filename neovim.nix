{ pkgs,... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      clang-tools
      lua-language-server
      pyright
    ];
    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
