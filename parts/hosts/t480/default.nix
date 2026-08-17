{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.t480 = withSystem "x86_64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
      inputs.self.nixosModules.default
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
          self'.packages.jujutsu
          self'.packages.helium
          # inputs.wasmcarts.packages.${stdenv.hostPlatform.system}.engine-linux
          pkgs.lazygit
          pkgs.pinta
          pkgs.zoom-us
          # pkgs.ventoy
          pkgs.signal-desktop
          pkgs.vesktop
          pkgs.element-desktop
          pkgs.ungoogled-chromium
          pkgs.ripgrep-all
        ];

        programs = {
          niri = {
            enable = true;
            useNautilus = false;
            package = (self'.packages.niri-noctalia5-activate-linux.apply {
              settings.outputs."eDP-1".scale = 1.0;
            }).wrapper;
          };
        };

        services = {
          mullvad-vpn.enable = true;
        };
      })
    ];
  });
}
