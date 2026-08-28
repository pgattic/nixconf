{ config, inputs, withSystem, ... }: {
  flake.homeConfigurations."pgattic@wasmcruncher" = withSystem "x86_64-linux" ({ self', ... }: inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };

    modules = [
      config.flake.homeModules.base
      config.flake.homeModules.desktop
      config.flake.homeModules.stylix
      config.flake.homeModules.browser

      ({ pkgs, ... }: {
        targets.genericLinux.enable = true;
        home.packages = [
          self'.packages.foot
          pkgs.zotero
        ];
      })
    ];
  });
}
