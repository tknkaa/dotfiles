{ pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./neovim.nix
    ./direnv.nix
    ./development.nix
    ./wezterm.nix
    ./browser.nix
    ./apps.nix
    ./starship.nix
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
      bat
      bottom
      eza
      httpie
      ripgrep
      xclip
      wl-clipboard
    ];
  };
  programs.home-manager.enable = true;
}
