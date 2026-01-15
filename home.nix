{ pkgs, ... }:

{
  imports = [
    ./home/apps.nix
    ./home/browser.nix
    ./home/development.nix
    ./home/direnv.nix
    ./home/helix.nix
    ./home/neovim.nix
    ./home/starship.nix
    ./home/vscode.nix
    ./home/wezterm.nix
    ./home/zed-editor.nix
    ./home/zsh.nix
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
