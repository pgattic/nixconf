{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.preston-amd = withSystem "x86_64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.self.nixosModules.options
      inputs.self.nixosModules.default
      inputs.self.nixosModules.desktop-default
      inputs.self.nixosModules.stylix
      inputs.self.nixosModules.browser

      ({ pkgs, ... }: {
        networking.hostName = "preston-amd";
        system.stateVersion = "25.11";

        environment.systemPackages = [
          self'.packages.foot-rude-sfw
          self'.packages.luanti-client
          self'.packages.desktop
          self'.packages.sioyek
          self'.packages.neovim
          self'.packages.btop
          self'.packages.git
          pkgs.signal-desktop
          pkgs.lazygit
          pkgs.codex
          pkgs.cursor-cli
          pkgs.ungoogled-chromium
          pkgs.nix-tree
        ];

        programs.niri = {
          enable = true;
          useNautilus = false;
          package = self'.packages.niri-activate-linux;
        };
      })
    ];
  });
}

