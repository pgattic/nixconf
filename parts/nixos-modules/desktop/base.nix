{ self, ... }: {
  flake.nixosModules.desktop-base = { config, lib, pkgs, ... }: {
    boot.plymouth.enable = lib.mkDefault true;
    boot.loader.systemd-boot.consoleMode = "max"; # Make plymouth full resolution
    xdg.portal.xdgOpenUsePortal = true;

    console.colors = with self.theme; [
      base00 # 0: Normal Black
      base08 # 1: Normal Red
      base0B # 2: Normal Green
      base0A # 3: Normal Yellow
      base0D # 4: Normal Blue
      base0E # 5: Normal Magenta
      base0C # 6: Normal Cyan
      base05 # 7: Normal White
      base03 # 8: Bright Black (Gray)
      base08 # 9: Bright Red
      base0B # 10: Bright Green
      base0A # 11: Bright Yellow
      base0D # 12: Bright Blue
      base0E # 13: Bright Magenta
      base0C # 14: Bright Cyan
      base07 # 15: Bright White
    ];

    services = {
      upower.enable = lib.mkDefault true;
      greetd = {
        enable = lib.mkDefault true;
        settings.default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --remember --asterisks --time --time-format \"%a %b %d %I:%M %p\" --window-padding 2 --theme \"border=blue;action=blue;time=blue;button=gray\" --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --session-wrapper ${config.services.displayManager.sessionData.wrapper}";
          user = "greeter";
        };
      };
    };
  };
}
