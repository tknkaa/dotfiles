{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "tknkaa";
    userEmail = "email address here";
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    extensions = with pkgs; [ gh-markdown-preview ]; # オススメ
    settings = {
      editor = "nvim";
    };
  };
}
