{ config
, ...
}:
{
  xdg.configFile = {
    "Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/home/vscode/settings.json";
  };
}
