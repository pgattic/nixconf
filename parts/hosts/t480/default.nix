{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.t480 = withSystem "x86_64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
      inputs.self.nixosModules.desktop-default
      inputs.self.nixosModules.remote-builder

      ({ pkgs, ... }: {
        networking.hostName = "t480";
        system.stateVersion = "25.05";

        environment.systemPackages = [
          self'.packages.foot
          self'.packages.luanti-client
          self'.packages.desktop
          self'.packages.neovim
          self'.packages.btop
          self'.packages.git
          self'.packages.bambu-studio
          self'.packages.helium
          pkgs.lazygit
          pkgs.signal-desktop
          pkgs.vesktop
          pkgs.element-desktop
          pkgs.ripgrep-all
        ];

        programs.niri = {
          enable = true;
          package = (self'.packages.niri-activate-linux.apply {
            settings.outputs."eDP-1".scale = 1.0;
          }).wrapper;
        };
      })
    ];
  });
}
