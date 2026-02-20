{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    settings = fromTOML (builtins.readFile ./config.toml);
    languages = fromTOML (builtins.readFile ./languages.toml);
    extraPackages = with pkgs; [
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.svelte-language-server
      gopls
      pyright
      clang-tools
      nixd
      rust-analyzer
    ];
  };
}
