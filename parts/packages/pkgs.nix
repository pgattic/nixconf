{
  perSystem = { lib, pkgs, ... }: let
    files = [
      ./_pkgs/horizon-launcher.nix
      ./_pkgs/horizon-server.nix
    ];
    derivs = builtins.map (file: pkgs.callPackage file { }) files;
  in {
    packages = lib.genAttrs' derivs (pkg: {
      name = pkg.pname;
      value = pkg;
    });
  };
}
