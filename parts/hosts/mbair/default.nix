{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.mbair = withSystem "aarch64-linux" ({ self', system, ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
      inputs.home-manager.nixosModules.home-manager
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
        boot.loader.systemd-boot.configurationLimit = 3;
        boot.kernelPackages = lib.mkForce inputs.asahix.packages.${system}.linux_asahi_fairydust;

        # Uncomment this to support WPA3 (at the cost of some other connections working)
        # networking.networkmanager.wifi.backend = "iwd";
        # networking.wireless.iwd = {
        #   enable = true;
        #   settings.General.EnableNetworkConfiguration = true;
        # };

        nix.settings = {
          substituters = lib.mkAfter [ "https://asahix.cachix.org" ];
          trusted-public-keys = lib.mkAfter [ "asahix.cachix.org-1:SDzLl9HW7kV2h/6yBCZwjhveL2HUjjdI0x+qFB0I54Y=" ];
        };

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
          self'.packages.foot
          self'.packages.luanti-client
          self'.packages.desktop
          self'.packages.helium
          self'.packages.nestopia-ue
          inputs.wasmcarts.packages.${system}.engine-linux
          pkgs.signal-desktop
          pkgs.element-desktop
          pkgs.lazygit
          pkgs.codex
          pkgs.cursor-cli
          pkgs.vesktop
          pkgs.whatsapp-electron
          pkgs.kopuz
        ];

        environment.systemPackages = [
          self'.packages.neovim
          self'.packages.btop
          self'.packages.git
          pkgs.nix-tree
        ];

        programs.niri = {
          enable = true;
          package = (self'.packages.niri-activate-linux.apply {
            settings.outputs."eDP-1".scale = 1.5;
          }).wrapper;
        };
      })
    ];
  });
}
