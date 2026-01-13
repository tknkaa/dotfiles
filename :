{
  programs.zsh = {
    enable = true;
    autocd = true; # cdなしでファイルパスだけで移動
    enableCompletion = true; # 自動補完
    autosuggestion.enable = true; # 入力サジェスト
    syntaxHighlighting.enable = true; # シンタックスハイライト
    shellAliases = {
      cat = "bat";
      grep = "rg";
      ls = "eza --icons always --classify always";
      tree = "eza --icons always --classify always --tree";
      n = "nvim";
      c = "copilot";
    };
    initContent = ''
      export GEMINI_API_KEY="$(cat /run/secrets/gemini_api_key)"
    '';
  };
}
