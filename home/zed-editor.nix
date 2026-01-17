{ config
, ...
}:
{
  programs.zed-editor = {
    enable = true;
  };

  # Create symlinks for Zed configuration files
  xdg.configFile = {
    "zed/settings.json".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/home/zed/settings.json";

    "zed/keymap.json".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/home/zed/keymap.json";

    "zed/themes".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/home/zed/themes";
  };
}
