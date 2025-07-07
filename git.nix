{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Git用のユーザー名";
    userEmail = "Git用のメールアドレス";
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
