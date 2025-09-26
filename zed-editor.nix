{
  programs.zed-editor = {
    enable = true;
    userSettings = {
      vim_mode = true;
      theme = "Dracula";
      ui_font_size = 20;
      buffer_font_size = 20;
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
