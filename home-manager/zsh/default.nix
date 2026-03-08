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
      zed = "zeditor";
    };
    initContent = ''
      export PATH="$HOME/.cargo/bin:$PATH"
      export DENO_DIR="$HOME/.cache/deno"
      export ZENO_HOME="$HOME/.config/zeno"
      export ZENO_DISABLE_EXECUTE_CACHE_COMMAND=1

      if [[ ! -d "$HOME/.cache/zeno-root" ]]; then
        cp -r ${pkgs.fetchFromGitHub {
          owner  = "yuki-yano";
          repo   = "zeno.zsh";
          rev    = "main";
          sha256 = "sha256-IPYj4hJ4N5guqgpdJbo2poA+W/KuxkoHInhId4GcGHs=";
        }} "$HOME/.cache/zeno-root"
        chmod -R u+w "$HOME/.cache/zeno-root"
      fi
      export ZENO_ROOT="$HOME/.cache/zeno-root"
      source "$ZENO_ROOT/zeno-plugin.zsh"

      export GEMINI_API_KEY="$(cat /run/secrets/gemini_api_key)"
      export KAGGLE_API_TOKEN="$(cat /run/secrets/kaggle_api_token)"
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
      if [[ -n $ZENO_LOADED ]]; then
        bindkey ' '  zeno-auto-snippet
        bindkey '^m' zeno-auto-snippet-and-accept-line
        bindkey '^i'  zeno-completion
        bindkey '^x ' zeno-insert-snippet
      fi
    '';
  };
  home.file.".config/zeno/config.yml".text = ''
    snippets:
      - name: git status
        keyword: gst
        snippet: git status --short --branch
  '';
}
