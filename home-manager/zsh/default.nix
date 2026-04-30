{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autocd = false;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      cat = "bat";
      grep = "rg";
      ls = "eza --icons always --classify always";
      tree = "eza --icons always --classify always --tree";
      n = "nvim";
      c = "copilot";
      a = "antigravity";
      gst = "git status";
      glg = "git log --oneline -5";
    };
    initContent = ''
      export PATH="$HOME/.cargo/bin:$PATH"
      export PATH="$HOME/.npm-global/bin:$PATH"
      export PATH="$HOME/go/bin:$PATH"

      export GEMINI_API_KEY="$(cat /run/secrets/gemini_api_key)"
      export GOOGLE_GENERATIVE_AI_API_KEY="$(cat /run/secrets/gemini_api_key)"
      export KAGGLE_API_TOKEN="$(cat /run/secrets/kaggle_api_token)"
      export CLOUDFLARE_ACCOUNT_ID="$(cat /run/secrets/cloudflare_account_id)"
      export OPENSSL_DIR="$(dirname $(dirname $(which openssl)))"
      export SSL_CERT_DIR="/etc/ssl/certs"
      export SSL_CERT_FILE="/etc/ssl/certs/ca-bundle.crt"
      eval "$(zoxide init zsh --cmd cd)"
      ni() {
        local file
        file=$(git ls-files | fzf) && nvim "$file"
      }
    '';
  };
}
