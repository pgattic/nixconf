{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.preston-amd = withSystem "x86_64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.self.nixosModules.default
      inputs.self.nixosModules.desktop-default

      ({ pkgs, ... }: {
        networking.hostName = "preston-amd";
        system.stateVersion = "25.11";
        boot.initrd.kernelModules = [ "amdgpu" ];
        boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

        users.users.pgattic.extraGroups = [ "dialout" ];

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs; };
          users.pgattic.imports = [
            inputs.self.homeModules.base
            inputs.self.homeModules.desktop
            inputs.self.homeModules.stylix
            inputs.self.homeModules.browser
          ];
        };

        environment.systemPackages = [
          self'.packages.foot-rude-sfw
          self'.packages.luanti-client
          self'.packages.desktop
          self'.packages.neovim
          self'.packages.btop
          self'.packages.git
          self'.packages.helium
          self'.packages.jujutsu
          pkgs.kopuz
          pkgs.signal-desktop
          pkgs.lazygit
          pkgs.codex
          pkgs.cursor-cli
          pkgs.nix-tree
          pkgs.kicad
        ];

        programs.niri = {
          enable = true;
          useNautilus = false;
          package = (self'.packages.niri-noctalia5-activate-linux.apply {
            settings.outputs."HDMI-A-1".mode = "1920x1080@100.00";
          }).wrapper;
        };
      })
    ];
  });
}
