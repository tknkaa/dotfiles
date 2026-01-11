{ pkgs, ... }:

{
  imports = [
    ./helix.nix
    ./zsh.nix
    ./neovim.nix
    ./direnv.nix
    ./development.nix
    ./wezterm.nix
    ./browser.nix
    ./apps.nix
    ./starship.nix
    ./zed-editor.nix
    ./vscode.nix
  ];
  fonts.fontconfig.enable = true;
  home = rec {
    username = "tknkaa";
    homeDirectory = "/home/${username}";
    stateVersion = "22.11";
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      zoom-us
      bat
      bottom
      eza
      httpie
      ripgrep
      xclip
      wl-clipboard
      conda
      unzip
      openssl
      nixfmt-tree
      nil
      nixd
      vscode
      dig
      uv
      gemini-cli
      gh
      github-copilot-cli
      obsidian
    ];
    pointerCursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
      gtk.enable = true;
    };
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
