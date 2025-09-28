{
  pkgs,
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
      "lua"
      "dracula"
    ];
    extraPackages = [ pkgs.nixd ];
    userSettings = {
      vim_mode = true;
      theme = "Dracula";
      ui_font_size = 20;
      buffer_font_size = 20;
      relative_line_numbers = true;
      lsp = {
        nix = {
          binary = {
            path_lookup = true;
          };
        };
      };
    };

    userKeymaps = [
      {
        context = "Editor && vim_mode == insert && !menu";
        bindings = {
          "j k" = "vim::NormalBefore";
        };
      }
    ];
  };
}
