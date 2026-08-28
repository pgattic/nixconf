{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.mbair = withSystem "aarch64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
      inputs.home-manager.nixosModules.home-manager
      inputs.self.nixosModules.default
      inputs.self.nixosModules.desktop-default
      inputs.self.nixosModules.remote-builder
      inputs.self.nixosModules.work

      ({ lib, pkgs, ... }: {
        networking.hostName = "mbair";
        system.stateVersion = "25.11";
        boot.loader.efi.canTouchEfiVariables = false;
        # Use `--impure` while building
        hardware.asahi = {
          enable = true;
          peripheralFirmwareDirectory = /etc/nixos/firmware;
        };

        # Uncomment this to support WPA3 (at the cost of some other connections working)
        # networking.networkmanager.wifi.backend = "iwd";
        # networking.wireless.iwd = {
        #   enable = true;
        #   settings.General.EnableNetworkConfiguration = true;
        # };

        nix.settings = {
          substituters = lib.mkAfter [ "https://nixos-apple-silicon.cachix.org" ];
          trusted-public-keys = lib.mkAfter [ "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20=" ];
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

        environment.systemPackages = [
          self'.packages.foot
          self'.packages.luanti-client
          self'.packages.desktop
          self'.packages.neovim
          self'.packages.btop
          self'.packages.git
          self'.packages.helium
          self'.packages.nestopia-ue
          inputs.wasmcarts.packages.${pkgs.stdenv.hostPlatform.system}.engine-linux
          pkgs.signal-desktop
          pkgs.element-desktop
          pkgs.lazygit
          pkgs.codex
          pkgs.cursor-cli
          pkgs.vesktop
          pkgs.nix-tree
          pkgs.whatsapp-electron
          pkgs.kopuz
        ];

        programs.niri = {
          enable = true;
          useNautilus = false;
          package = (self'.packages.niri-noctalia5-activate-linux.apply {
            settings.outputs."eDP-1".scale = 1.5;
          }).wrapper;
        };
      })
    ];
  });
}
