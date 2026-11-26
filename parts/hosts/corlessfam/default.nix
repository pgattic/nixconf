{ inputs, self, withSystem, ... }: {
  flake.nixosConfigurations.corlessfam = withSystem "x86_64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.self.nixosModules.new-default
      inputs.self.nixosModules.agenix
      inputs.self.nixosModules.dynamic-dns
      inputs.self.nixosModules.nginx
      inputs.self.nixosModules.luanti-server
      inputs.self.nixosModules.minecraft-java-server
      inputs.self.nixosModules.jellyfin
      inputs.self.nixosModules.immich
      # inputs.self.nixosModules.firefly
      inputs.self.nixosModules.audiobookshelf
      inputs.self.nixosModules.copyparty
      inputs.self.nixosModules.qbittorrent
      inputs.self.nixosModules.cookbook
      inputs.self.nixosModules.forgejo
      inputs.self.nixosModules.traccar
      inputs.self.nixosModules.barp
      inputs.self.nixosModules.yubal
      inputs.self.nixosModules.scripguessr

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
            pgattic.openssh.authorizedKeys.keys = self.lib.keys.ssh;
          };
        };

        nixconf = {
          desktop.enable = false;
          terminal.apps = [
            pkgs.smartmontools # Used for hard drive SMART tests (`sudo smartctl -x /dev/sdX`)
            # pkgs.waypipe
            self'.packages.git
            pkgs.lazygit
            pkgs.codex
            pkgs.claude-code
            pkgs.herdr
          ];
        };

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
      })
    ];
  });
}
