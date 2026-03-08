{ pkgs, ... }:
{
  # Spotify TUI
  programs.ncspot.enable = true;

  # OBS
  programs.obs-studio.enable = true;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Fonts
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono

    # CLI utilities
    bat
    bottom
    eza
    httpie
    ripgrep
    xclip
    wl-clipboard
    unzip
    dig

    # Communication & Apps
    discord
    slack
    gemini-cli
    obsidian
  ];

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };
}
