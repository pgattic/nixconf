{
  flake.nixosModules.bigscreen = { lib, pkgs, ... }: {
    # Upstream package is currently broken
    nixpkgs.overlays = [
      (final: prev: {
        kdePackages = prev.kdePackages // {
          plasma-bigscreen = prev.kdePackages.plasma-bigscreen.overrideAttrs (old: {
            buildInputs = (old.buildInputs or [ ]) ++ [ prev.kdePackages.kdeconnect-kde ];
            preFixup = ''
              wrapQtApp $out/bin/plasma-bigscreen-wayland \
                --prefix QML2_IMPORT_PATH : "${prev.kdePackages.kdeconnect-kde}/lib/qt-6/qml" \
                --prefix PATH : "${prev.kdePackages.plasma-workspace}/bin"
            '';
          });
        };
      })
    ];

    services.desktopManager.plasma6.enable = true;
    services.speechd.enable = lib.mkForce true;
    xdg.portal.configPackages = [ pkgs.kdePackages.plasma-bigscreen ];

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      konsole
      kate
      dolphin
      elisa
      gwenview
      okular
      spectacle
      ark
      kcalc
      kcolorchooser
      print-manager
      plasma-browser-integration
      krdp
      kfind
      khelpcenter
      ksystemlog
      qrca
    ];

    services.displayManager = {
      defaultSession = "plasma-bigscreen-wayland";
      sessionPackages = [ pkgs.kdePackages.plasma-bigscreen ];
      sddm = {
        enable = true;
        theme = "breeze";
        wayland.enable = true;
        enableHidpi = true;
        settings = {
          Autologin = {
            Session = "plasma-bigscreen-wayland";
            User = "pgattic";
          };
        };
      };
    };
  };
}
