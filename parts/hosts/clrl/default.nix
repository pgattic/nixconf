{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.clrl = withSystem "x86_64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.self.nixosModules.desktop-default

      ({ lib, pkgs, ... }: let
        niri-pkg = (self'.packages.niri.apply {
          env.WGPU_BACKEND = "gl"; # Fixes WGPU apps like cosmic
          settings.spawn-at-startup = [
            [ (lib.getExe self'.packages.noctalia) ]
            [ (lib.getExe self'.packages.helium) ]
          ];
        }).wrapper;
      in {
        networking.hostName = "clrl";
        system.stateVersion = "25.05";

        # The hardware doesn't support uefi boot
        boot.loader = {
          systemd-boot.enable = false;
          grub = {
            enable = true;
            device = "/dev/sda";
          };
        };

        environment.systemPackages = [
          self'.packages.foot
          self'.packages.desktop
          self'.packages.git
          self'.packages.helium
          pkgs.lazygit
          pkgs.kopuz
        ];

        programs.niri.package = niri-pkg;

        services.greetd.settings.default_session = lib.mkForce {
          command = lib.getExe niri-pkg;
          user = "pgattic";
        };
      })
    ];
  });
}
