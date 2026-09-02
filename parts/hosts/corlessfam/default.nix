{ inputs, self, withSystem, ... }: {
  flake.nixosConfigurations.corlessfam = withSystem "x86_64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.self.nixosModules.default
      inputs.self.nixosModules.agenix
      inputs.self.nixosModules.dynamic-dns
      inputs.self.nixosModules.nginx
      inputs.self.nixosModules.luanti-server
      inputs.self.nixosModules.jellyfin
      inputs.self.nixosModules.immich
      inputs.self.nixosModules.firefly
      inputs.self.nixosModules.audiobookshelf
      inputs.self.nixosModules.copyparty
      inputs.self.nixosModules.qbittorrent
      inputs.self.nixosModules.cookbook
      inputs.self.nixosModules.forgejo
      inputs.self.nixosModules.traccar
      inputs.self.nixosModules.barp

      ({ lib, pkgs, ... }: {
        boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
        boot.supportedFilesystems = [ "zfs" ];
        boot.zfs.extraPools = [ "tank" ]; # Automatic mounting
        services.zfs.autoScrub.enable = true;
        boot.zfs.forceImportRoot = false; # Will be the default setting soon

        networking.hostId = "6e005e0f"; # head -c 8 /etc/machine-id
        networking.hostName = "corlessfam";
        system.stateVersion = "25.05";

        nix.settings = {
          max-jobs = lib.mkDefault 4;
          trusted-users = lib.mkAfter [ "nixbuilder" ];
        };

        users = {
          groups.nixbuilder = {};
          users = {
            nixbuilder = {
              isSystemUser = true;
              group = "nixbuilder";
              home = "/var/lib/nixbuilder";
              createHome = true;
              shell = pkgs.bashInteractive;
              openssh.authorizedKeys.keys = self.lib.keys.builder;
            };
            pgattic = {
              shell = (self'.packages.nushell-env.apply {
                runtimePkgs = [
                  self'.packages.neovim
                  self'.packages.git
                  pkgs.lazygit
                ];
              }).wrapper;
              packages = [
                self'.packages.foot
                self'.packages.helium
                pkgs.xemu
                pkgs.xenia-canary
              ];
              openssh.authorizedKeys.keys = self.lib.keys.ssh;
            };
          };
        };

        environment.systemPackages = [
          pkgs.smartmontools # Used for hard drive SMART tests (`sudo smartctl -x /dev/sdX`)
          pkgs.waypipe
          pkgs.kdePackages.plasma-bigscreen
          pkgs.jellyfin-desktop
        ];

        services = {
          openssh.enable = true;
          smartd.enable = true; # added alongside `smartmontools` package

          nginx = {
            virtualHosts = {
              "corlessfamily.net" = {
                enableACME = true;
                forceSSL = true;
                serverAliases = [ "www.corlessfamily.net" ];
                root = "/tank/media/home/public";
              };
            };
          };
        };

        # Plasma Bigscreen config

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
      })
    ];
  });
}
