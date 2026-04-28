{ config, ... }:
{
  programs = {
    firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
    };
    google-chrome.enable = true;
  };
}
