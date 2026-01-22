{ pkgs, ... }:
{
  home.packages = with pkgs.gnomeExtensions; [
    paperwm
  ];
  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [ "paperwm@paperwm.github.com" ];
    };

    "org/gnome/shell/extensions/paperwm/keybindings" = {
      switch-left = [ "<Super>h" ];
      switch-right = [ "<Super>l" ];
      switch-up = [ "<Super>k" ];
      switch-down = [ "<Super>j" ];
    };
  };
}
