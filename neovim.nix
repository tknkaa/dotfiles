{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
