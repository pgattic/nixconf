{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.preston-amd = withSystem "x86_64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.home-manager.nixosModules.home-manager
      inputs.self.nixosModules.new-default

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

        users.users.pgattic.packages = [
          pkgs.signal-desktop
          pkgs.kicad
        ];

        nixconf = {
          desktop.activate-linux.enable = true;
          terminal.apps = [
            self'.packages.git
            self'.packages.jujutsu
            pkgs.lazygit
            pkgs.gh
            pkgs.claude-code
            pkgs.cursor-cli
            pkgs.nix-tree
          ];
        };

        programs.niri.package = (self'.packages.niri.apply {
          settings.outputs."HDMI-A-1".mode = "1920x1080@100.00";
        }).wrapper;
      })
    ];
  });
}
