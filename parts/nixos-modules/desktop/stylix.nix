{ inputs, ... }: {
  flake.nixosModules.stylix = { pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];
    stylix = {
      enable = true;
      homeManagerIntegration.autoImport = false;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-gray.yaml";
      targets.plymouth.enable = false;
    };
  };
}
