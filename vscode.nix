{
  programs.vscode = {
    enable = true;

    profiles.default = {
      userSettings = {
        "editor.fontSize" = 18;
        "chat.editor.fontSize" = 20;
        "terminal.integrated.fontSize" = 18;
        "debug.console.fontSize" = 20;
        "scm.inputFontSize" = 20;
        "notebook.markup.fontSize" = 20;
        "notebook.output.fontSize" = 20;
        "markdown.preview.fontSize" = 20;
        "editor.mouseWheelZoom" = true;
        "window.zoomLevel" = 1.5;
        "editor.fontFamily" = "Consolas, 'Courier New', monospace";
        "terminal.integrated.fontFamily" = "Consolas, 'Courier New', monospace";

        "extensions.experimental.affinity" = {
          "asvetliakov.vscode-neovim" = 1;
        };

        "vscode-neovim.compositeKeys" = {
          "jk" = {
            command = "vscode-neovim.escape";
          };
        };
      };
    };
  };
}
