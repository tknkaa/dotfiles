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
    ./sway.nix
  ];
  fonts.fontconfig.enable = true;
  home = rec {
    username = "tknkaa";
    homeDirectory = "/home/${username}";
    stateVersion = "22.11";
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      vscode
      zoom-us
      bat
      bottom
      eza
      httpie
      ripgrep
      conda
      openssl
      nixfmt-tree
      gemini-cli
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

  programs.waybar.settings.main = {
    layer = "top";
    position = "top";
    height = 30;
    modules-left = [
      "sway/workspaces"
      "sway/mode"
    ];
    modules-center = [ "sway/window" ];
    modules-right = [
      "pulseaudio"
      "network"
      "cpu"
      "memory"
      "clock"
    ];

    "pulseaudio" = {
      "scroll-step" = 5;
      "format" = "{volume}% {icon}";
      "format-muted" = " Muted";
      "format-icons" = {
        "default" = [
          ""
          ""
          ""
        ];
      };
      "on-click" = "pavucontrol";
      "on-scroll-up" = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
      "on-scroll-down" = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
    };
  };
}
