{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = "tokyonight";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };
      keys = {
        insert = {
          j = {
            k = "normal_mode";
          };
        };
      };
    };
    languages = {
      language-server = {
        nixd = {
          command = "nixd";
        };
        rust-analyzer = {
          command = "rust-analyzer";
        };
      };
      language = [
        {
          name = "nix";
          file-types = [ "nix" ];
          language-servers = [ "nixd" ];
        }
      ];
    };
    extraPackages = with pkgs; [
      nixd
      rust-analyzer
    ];
  };
}
