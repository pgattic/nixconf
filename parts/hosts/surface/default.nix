{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.surface = withSystem "x86_64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
      inputs.self.nixosModules.new-default

      ({ pkgs, ... }: {
        networking.hostName = "surface";
        system.stateVersion = "25.05";

        # Enable power button, volume rocker
        boot.initrd.kernelModules = [ "pinctrl_sunrisepoint" ]; # lsmod | grep pinctrl

        users.users.pgattic.packages = [
          self'.packages.luanti-client
          pkgs.lazygit
          pkgs.rnote
        ];

        nixconf = {
          desktop.variant = "touch";
          terminal.apps = [
            self'.packages.git
          ];
          swapfile.enable = false; # This device has a swap partition already
          remote-builder.enable = true;
        };
        programs.niri.package = (self'.packages.niri-touch.apply ({ lib, ... }: {
          settings.spawn-at-startup = [ [ (lib.getExe self'.packages.lisgd-surface) ] ];
        })).wrapper;
      })
    ];
  });
}
