{
  programs.starship = {
    enable = true;
    settings = {
      format = "$directory[ ](fg:#88C0D0 bg:#1d2230)$git_branch$git_status[ ](fg:#1d2230)\n$character";

      right_format = "$cmd_duration$username✨$time";

      add_newline = true;

      # 各モジュール設定
      username = {
        style_user = "white bold";
        style_root = "black bold";
        format = "user: [$user]($style) ";
        disabled = false;
      };

      fill = {
        symbol = " ";
      };

      directory = {
        style = "fg:#2E3440 bg:#88C0D0 bold";
        truncation_length = 10;
        truncate_to_repo = false;
        truncation_symbol = "…/";
        read_only = " 󰌾 ";
        read_only_style = "fg:#f7768e bg:#1a1b26";
        format = "[ $path ]($style)[$read_only]($read_only_style)";

        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      aws = {
        disabled = true;
      };

      gcloud = {
        disabled = true;
      };

      git_branch = {
        symbol = "";
        style = "bg:#1d2230";
        format = "[[ $symbol $branch ](fg:#769ff0 bg:#1d2230)]($style)";
      };

      git_status = {
        style = "bg:#1d2230";
        format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#1d2230)]($style)";
      };

      cmd_duration = {
        min_time = 1;
        style = "fg:#e0af68";
        format = "[$duration]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        format = "[[   $time ](fg:#a0a9cb)]($style)";
      };

      character = {
        vimcmd_symbol = "[V](bold green) ";
      };
    };
  };
}
