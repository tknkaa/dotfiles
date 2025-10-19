{
  config,
  ...
}:
{
  xdg.configFile = {
    "Code/settings.json".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/.config/vscode/settings.json";
  };
}
