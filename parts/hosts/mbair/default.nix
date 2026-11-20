{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.mbair = withSystem "aarch64-linux" ({ self', system, ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
      inputs.asahix.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      inputs.bootmap.nixosModules.default
      inputs.self.nixosModules.desktop-default

      ({ lib, pkgs, ... }: {
        networking.hostName = "mbair";
        system.stateVersion = "25.11";
        # Use `--impure` while building
        hardware.asahi = {
          enable = true;
          peripheralFirmwareDirectory = /etc/nixos/firmware;
        };
        boot.loader.efi.canTouchEfiVariables = false;
        boot.kernelPackages = lib.mkForce pkgs.linuxPackages_asahi-fairydust;

        services.bootmap = {
          enable = true;
          initrd = true;
        };
        boot.plymouth.enable = false;

        # Uncomment this to support WPA3 (at the cost of some other connections working)
        # networking.networkmanager.wifi.backend = "iwd";
        # networking.wireless.iwd = {
        #   enable = true;
        #   settings.General.EnableNetworkConfiguration = true;
        # };

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs; };
          users.pgattic.imports = [
            inputs.self.homeModules.base
            inputs.self.homeModules.desktop
            inputs.self.homeModules.stylix
          ];
        };

        users.users.pgattic.packages = [
          self'.packages.foot
          self'.packages.luanti-client
          self'.packages.desktop
          self'.packages.helium
          self'.packages.nestopia-ue
          self'.packages.cosmic-viewer
          self'.packages.wheelwizard-fhs
          # self'.packages.horizon-launcher
          inputs.wasmcarts.packages.${system}.engine-linux
          pkgs.signal-desktop
          pkgs.element-desktop
          pkgs.lazygit
          pkgs.codex
          pkgs.claude-code
          pkgs.cursor-cli
          pkgs.vesktop
          pkgs.whatsapp-electron
          (pkgs.prismlauncher.override {
            jdks = [ pkgs.jdk21 ];
          })
        ];

        environment.systemPackages = [
          self'.packages.neovim
          self'.packages.btop
          self'.packages.git
          pkgs.nix-tree
        ];

        programs.niri.package = self'.packages.niri-activate-linux;
      })
    ];
  });
}
