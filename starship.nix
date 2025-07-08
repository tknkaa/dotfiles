{

  # home.nix の中
  programs.starship = {
    enable = true;
    settings = {
      # 右プロンプトは非表示、改行は有効
      add_newline = true;
      right_format = "";

      # アイコンや特殊文字をなくしたシンプルなフォーマット
      format = "$directory[ ](fg:#88C0D0 bg:#1d2230)$git_branch$git_status[ ](fg:#1d2230)\n$character";

      directory = {
        style = "fg:#2E3440 bg:#88C0D0 bold";
        truncation_length = 10;
        truncation_symbol = "…/";
        # 読み取り専用アイコンを文字に変更
        read_only = " (ro)";
        read_only_style = "fg:#f7768e";
        format = "[ $path ]($style)[$read_only]($read_only_style)";
        # ディレクトリごとのアイコン設定を削除
      };

      # Gitブランチのアイコンを文字に変更
      git_branch = {
        symbol = "git:";
        style = "fg:#769ff0";
        format = "[$symbol $branch]($style)";
      };

      # Gitステータスの表示形式をブランチと統一
      git_status = {
        style = "fg:#769ff0";
        format = "[$all_status$ahead_behind]($style)";
      };

      # コマンド実行時間（このモジュールは元々アイコンなし）
      cmd_duration = {
        min_time = 1;
        style = "fg:#e0af68";
        format = "[$duration]($style)";
      };

      # プロンプトの最後の記号
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[V](bold green)";
      };
    };
  };
}
