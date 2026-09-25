{ inputs, ... }: {
  perSystem = { pkgs, ... }: let
    wlib = inputs.nix-wrapper-modules.lib;

    wrapCosmicApp = package: wlib.wrapPackage {
      inherit pkgs package;
      env.XDG_CONFIG_HOME = ./config;
      suffixVar = [
        [
          "XDG_DATA_DIRS"
          ":"
          "${pkgs.papirus-icon-theme}/share"
        ]
      ];
    };
  in {
    packages = builtins.mapAttrs (_: wrapCosmicApp) {
      inherit (pkgs) cosmic-files;
    };
  };
}
