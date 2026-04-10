{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    settings = fromTOML (builtins.readFile ./config.toml);
    languages = fromTOML (builtins.readFile ./languages.toml);
    extraPackages = with pkgs; [
      typescript-language-server
      vscode-langservers-extracted
      svelte-language-server
      gopls
      pyright
      clang-tools
      nixd
      rust-analyzer
    ];
  };
}
