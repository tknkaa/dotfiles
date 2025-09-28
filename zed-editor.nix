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
    extraPackages = with pkgs; [
      nixd
      nil
    ];
    userSettings = {
      vim_mode = true;
      theme = "Dracula";
      ui_font_size = 24;
      buffer_font_size = 24;
      relative_line_numbers = true;
      lsp = {
        nix = {
          binary = {
            path_lookup = true;
          };
        };
        rust-analyzer = {
          initialization_options = {
            checkOnSave = {
              enable = false;
            };
            settings = {
              procMacro = {
                enable = false;
              };
              cargo = {
                runBuildScripts = false;
              };
              inlayHints = {
                enable = false;
              };
              lens = {
                enable = false;
              };
              hover = {
                enable = true;
              };
              completion = {
                enable = true;
              };
              diagnostics = {
                enable = false;
              };
              callInfo = {
                enable = false;
              };
            };
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
