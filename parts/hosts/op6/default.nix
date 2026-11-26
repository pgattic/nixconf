{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.op6 = withSystem "aarch64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      (import "${inputs.mobile-nixos}/lib/configuration.nix" { device = "oneplus-enchilada"; })
      inputs.self.nixosModules.new-default

      ({ pkgs, ... }: {
        networking.hostName = "op6";
        system.stateVersion = "26.05";
        boot.loader.systemd-boot.enable = false; # Overriding from base

        services.logind.settings.Login = {
          HandlePowerKey = "ignore"; # The kernel handles this already
          HandlePowerKeyLongPress = "poweroff";
        };

        users.users.pgattic.packages = [
          self'.packages.luanti-client
        ];

        nixconf = {
          desktop.variant = "mobile";
          remote-builder.enable = true;
          swapfile.size = 2 * 1024;
        };
        programs.niri.package = (self'.packages.niri-mobile.apply ({ lib, ... }: {
          settings = {
            spawn-at-startup = [ [ (lib.getExe self'.packages.lisgd-op6) ] ];
            outputs."DSI-1".scale = 2.0;
          };
        })).wrapper;

        services = {
          openssh = {
            enable = true;
            settings.PasswordAuthentication = true;
          };
          displayManager.gdm.enable = true;
          displayManager.noctalia-greeter.enable = false;
          bootmap.enable = false;
        };
      })
    ];
  });
}
