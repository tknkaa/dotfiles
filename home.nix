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
  ];
  home = rec {
    username = "tknkaa";
    homeDirectory = "/home/${username}";
    stateVersion = "22.11";
    packages = with pkgs; [
      vscode
      bat
      bottom
      eza
      httpie
      ripgrep
    ];
  };
  programs.home-manager.enable = true;
}
