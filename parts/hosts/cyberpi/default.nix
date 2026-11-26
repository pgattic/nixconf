{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.cyberpi = withSystem "aarch64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
      inputs.self.nixosModules.new-default

      ({ pkgs, ... }: {
        boot.loader.systemd-boot.enable = false;
        boot.loader.efi.canTouchEfiVariables = false; # Might not matter if I set this

        hardware.raspberry-pi."4".fkms-3d.enable = true; # display output
        hardware.raspberry-pi."4".touch-ft5406.enable = true; # touchscreen input
        hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;
        hardware.deviceTree.enable = true;
        hardware.graphics = {
          enable = true;
          extraPackages = [ pkgs.mesa ];
        };

        networking.hostName = "cyberpi";
        system.stateVersion = "25.05";
        services.fwupd.enable = false;
        services.upower.enable = false;
        hardware.bluetooth.enable = false;

        users.users.pgattic.packages = [
          self'.packages.luanti-client
        ];

        nixconf = {
          desktop.variant = "touch";
          swapfile.enable = false;
          remote-builder.enable = true;
        };
        programs.niri.package = (self'.packages.niri-touch.apply {
          settings.input.mod-key = "Alt";
        }).wrapper;
        services.bootmap.enable = false;
      })
    ];
  });
}
