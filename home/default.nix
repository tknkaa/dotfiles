{ pkgs, ... }:

{
  imports = [
    ./apps.nix

    ./browser.nix
    ./development.nix
    ./direnv.nix
    ./helix.nix
    ./neovim.nix
    ./starship.nix
    ./vscode
    ./wezterm.nix
    ./zed    
    ./zsh.nix
    ./gnome.nix
  ];
  home = rec {
    username = "tknkaa";
    homeDirectory = "/home/${username}";
    stateVersion = "22.11";
  };
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "$HOME/Desktop";
    documents = "$HOME/Documents";
    download = "$HOME/Downloads";
    music = "$HOME/Music";
    publicShare = "$HOME/PublicShare";
    pictures = "$HOME/Pictures";
    templates = "$HOME/Templates";
    videos = "$HOME/Videos";
  };
  programs.home-manager.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
    };
  };

  home.sessionVariables = {
    BROWSER = "firefox";
  };
}
