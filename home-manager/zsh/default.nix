{
  programs.zsh = {
    enable = true;
    autocd = false;
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
      zed = "zeditor";
    };
    initContent = ''
      export GEMINI_API_KEY="$(cat /run/secrets/gemini_api_key)"
      export KAGGLE_API_TOKEN="$(cat /run/secrets/kaggle_api_token)"
      export PATH="$HOME/.cargo/bin:$PATH"
      export OPENSSL_DIR="$(dirname $(dirname $(which openssl)))"
      export SSL_CERT_DIR="/etc/ssl/certs"
      export SSL_CERT_FILE="/etc/ssl/certs/ca-bundle.crt"
      eval "$(zoxide init zsh --cmd cd)"
      cdi() {
        local dir
        dir=$(zoxide query -l | fzf) && cd "$dir"
      }
      ni() {
        local file
        file=$(git ls-files | fzf) && nvim "$file"
      }
    '';
  };
}
