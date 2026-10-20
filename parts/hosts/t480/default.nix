{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.t480 = withSystem "x86_64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
      inputs.self.nixosModules.desktop-default

      ({ pkgs, ... }: {
        networking.hostName = "t480";
        system.stateVersion = "25.05";

        environment.systemPackages = [
          self'.packages.desktop
          self'.packages.foot
          self'.packages.luanti-client
          self'.packages.git
          self'.packages.bambu-studio
          self'.packages.helium
          pkgs.codex
          pkgs.lazygit
        ];

        programs.niri.package = self'.packages.niri-activate-linux;
      })
    ];
  });
}
