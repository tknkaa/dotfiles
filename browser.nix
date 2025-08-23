{
  programs = {
    firefox.enable = true;
    google-chrome = {
      enable = true;
      commandLineArgs = [
        "--force-device-scale-factor=1.2"
      ];
    };
    vivaldi = {
      enable = true;
      commandLineArgs = [
        "--enable-features=WebUIDarkMode"
        "--force-dark-mode"
      ];
    };
  };
}
