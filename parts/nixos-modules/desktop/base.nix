{ inputs, moduleWithSystem, self, ... }: {
  flake.nixosModules.desktop-base = moduleWithSystem ({ self', ... }: { config, lib, pkgs, ... }: {
    imports = [
      inputs.bootmap.nixosModules.default
    ];

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

    services = {
      bootmap = { # From bootmap module
        enable = true;
        initrd = true;
      };
      upower.enable = lib.mkDefault true;
      gvfs.enable = lib.mkDefault true;
      displayManager.noctalia-greeter = {
        enable = lib.mkDefault true;
        settings = {
          appearance = {
            password_style = "random";
            wallpaper = {
              path = ../../../assets/wallpapers/wedding_temple.jpg;
              blur = 0.5;
              tint = 0.7;
            };
          };
          cursor = {
            theme = "Bibata-Modern-Classic";
            path = "${pkgs.bibata-cursors}/share/icons";
          };
        };
      };
    };

    programs = {
      niri = {
        enable = lib.mkDefault true;
        useNautilus = lib.mkDefault false;
        package = lib.mkDefault self'.packages.niri;
      };
      noctalia = {
        enable = lib.mkDefault true;
        systemd.enable = lib.mkDefault true;
        package = lib.mkDefault self'.packages.noctalia;
      };
    };
  });
}
