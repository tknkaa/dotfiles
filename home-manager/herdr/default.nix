{ pkgs, ... }:

{
  xdg.configFile."herdr/config.toml".source = ./config.toml;

  # notify-send, required for ui.toast.delivery = "system" in config.toml.
  # GNOME Shell already runs a notification daemon, so no separate daemon
  # (e.g. dunst) is needed here.
  home.packages = [ pkgs.libnotify ];
}
