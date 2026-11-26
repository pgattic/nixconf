{ moduleWithSystem, self, ... }: {
  flake.nixosModules.new-default = moduleWithSystem ({ self', ... }: { config, lib, pkgs, ... }: let
    cfg = config.nixconf.desktop;
  in {
    options.nixconf.desktop = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.nixconf.enable;
        description = "Whether to enable desktop features";
      };
      variant = lib.mkOption {
        type = lib.types.enum [ "default" "touch" "mobile" ];
        default = "default";
        description = "Which desktop variant to enable";
      };
      useDefaultApps = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to install default desktop applications";
      };
    };

    config = lib.mkIf cfg.enable {
      nixconf.networking.enable = lib.mkDefault true;
      nixconf.desktop.bluetooth.enable = lib.mkDefault true;

      boot.loader.systemd-boot.consoleMode = "max"; # Make bootmap full resolution
      xdg.portal.xdgOpenUsePortal = true;

      console.colors = with self.lib.theme; [
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

      fonts.packages = [
        pkgs.noto-fonts
        pkgs.noto-fonts-cjk-sans
        pkgs.noto-fonts-cjk-serif
      ];

      users.users.${config.nixconf.user}.packages = lib.mkIf cfg.useDefaultApps [
        self'.packages.sioyek
        pkgs.mpv-unwrapped
        self'.packages.cosmic-files
        self'.packages.helium
        self'.packages.cosmic-viewer
      ];

      services = {
        bootmap = { # From bootmap module
          enable = lib.mkDefault true;
          initrd = lib.mkDefault true;
        };
        upower.enable = lib.mkDefault true;
        gvfs.enable = lib.mkDefault true;
        displayManager.noctalia-greeter = {
          enable = lib.mkDefault true;
          cursorTheme = {
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Classic";
          };
          settings = {
            appearance = {
              password_style = "random";
              wallpaper = {
                path = ../../../assets/wallpapers/wedding_temple.jpg;
                blur = 0.5;
                tint = 0.7;
              };
            };
          };
        };
      };
    };
  });
}
