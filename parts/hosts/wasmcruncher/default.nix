{ config, inputs, withSystem, ... }: {
  flake.homeConfigurations."pgattic@wasmcruncher" = withSystem "x86_64-linux" ({ self', ... }: inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };

    modules = [
      config.flake.homeModules.base
      config.flake.homeModules.desktop
      config.flake.homeModules.stylix

      ({ pkgs, ... }: {
        targets.genericLinux.enable = true;
        home.packages = [
          self'.packages.foot
          self'.packages.desktop
          self'.packages.helium
          self'.packages.neovim
          self'.packages.git
          self'.packages.btop
          pkgs.zotero
          pkgs.lazygit
          pkgs.codex
          pkgs.nix-tree
        ];

        wayland.windowManager.niri = {
          enable = true;
          package = self'.packages.niri;
        };
      })
    ];
  });
}
