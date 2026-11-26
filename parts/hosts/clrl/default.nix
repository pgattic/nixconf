{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.clrl = withSystem "x86_64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.self.nixosModules.new-default

      ({ lib, pkgs, ... }: let
        niri-pkg = (self'.packages.niri.apply {
          env.WGPU_BACKEND = "gl"; # Fixes WGPU apps like cosmic
          settings.spawn-at-startup = [
            [ (lib.getExe self'.packages.helium) ]
          ];
        }).wrapper;
      in {
        networking.hostName = "clrl";
        system.stateVersion = "25.05";
        boot.initrd.kernelModules = [ "i915" ];

        # The hardware doesn't support uefi boot
        boot.loader = {
          systemd-boot.enable = false;
          grub = {
            enable = true;
            device = "/dev/sda";
          };
        };

        nixconf = {
          terminal.apps = [
            self'.packages.git
            pkgs.lazygit
          ];
        };

        programs.niri.package = niri-pkg;

        services.displayManager.noctalia-greeter.enable = false;
        services.greetd = {
          enable = true;
          settings.default_session = lib.mkForce {
            command = "${niri-pkg}/bin/niri-session";
            user = "pgattic";
          };
        };
      })
    ];
  });
}
