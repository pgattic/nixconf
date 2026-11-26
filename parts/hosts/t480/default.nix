{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.t480 = withSystem "x86_64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
      inputs.self.nixosModules.new-default

      ({ pkgs, ... }: {
        networking.hostName = "t480";
        system.stateVersion = "25.05";

        users.users.pgattic.packages = [
          self'.packages.luanti-client
          self'.packages.bambu-studio
          self'.packages.wheelwizard-fhs
          self'.packages.horizon-launcher
        ];

        nixconf = {
          desktop.activate-linux.enable = true;
          terminal.apps = [
            pkgs.gh
            pkgs.claude-code
          ];
          swapfile.enable = false; # This device has a swap partition already
        };
      })
    ];
  });
}
